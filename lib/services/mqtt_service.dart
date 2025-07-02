import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionStatusChanged = void Function(MqttConnectionState state);

class MqttService {
  static final MqttService _instance = MqttService._internal();
  MqttServerClient? client;
  final String _controlTopicPrefix = 'smartpower/device/control';

  factory MqttService({
    OnMessageReceived? onMessageReceived,
    OnConnectionStatusChanged? onConnectionStatusChanged,
    List<String> topics = const [
      'iot/monitoring',
      'smartpower/device/control',
      'smartpower/device/status',
      'smartpower/device/alert',
    ],
  }) {
    _instance.onMessageReceived = onMessageReceived;
    _instance.onConnectionStatusChanged = onConnectionStatusChanged;
    _instance.topics = topics;

    if (_instance.client == null) {
      _instance.client = MqttServerClient(_mqttBroker, _generateClientId());
      _instance._setupClient();
    }
    return _instance;
  }

  MqttService._internal();

  static const String _mqttBroker = 'broker.hivemq.com';
  static const int _mqttPort = 1883;
  late List<String> topics;
  OnMessageReceived? onMessageReceived;
  OnConnectionStatusChanged? onConnectionStatusChanged;
  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  static String _generateClientId() {
    return 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _setupClient() {
    client!.port = _mqttPort;
    client!.keepAlivePeriod = 30;
    client!.logging(on: false);

    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;
    client!.onSubscribed = _onSubscribed;
    client!.pongCallback = _onPong;

    client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(client!.clientIdentifier)
        .startClean()
        .withWillTopic('${client!.clientIdentifier}/status')
        .withWillMessage('offline')
        .withWillQos(MqttQos.atLeastOnce);
  }

  Future<bool> connect({int maxRetries = 3, int retryDelay = 2}) async {
    if (client == null) return false;

    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        debugPrint('Connecting to MQTT broker (attempt ${attempts + 1})...');
        await client!.connect();

        if (client!.connectionStatus?.state == MqttConnectionState.connected) {
          _subscribeToTopics();
          _listenForMessages();
          onConnectionStatusChanged?.call(MqttConnectionState.connected);
          return true;
        }
      } catch (e) {
        await Future.delayed(Duration(seconds: retryDelay));
      }
      attempts++;
    }
    onConnectionStatusChanged?.call(MqttConnectionState.disconnected);
    return false;
  }

  void _onConnected() => debugPrint('MQTT connection established');
  void _onDisconnected() =>
      onConnectionStatusChanged?.call(MqttConnectionState.disconnected);
  void _onSubscribed(String topic) => debugPrint('Subscribed to topic: $topic');
  void _onPong() => debugPrint('Ping response received');

  void _subscribeToTopics() {
    for (String t in topics) {
      client!.subscribe(t, MqttQos.atLeastOnce);
    }
  }

  void _listenForMessages() {
    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        try {
          final payload = message.payload as MqttPublishMessage;
          final content =
              MqttPublishPayload.bytesToStringAsString(payload.payload.message);
          final jsonData = jsonDecode(content) as Map<String, dynamic>;
          _handleIncomingMessage(message.topic, jsonData);
        } catch (e) {
          debugPrint('Error processing message: $e');
        }
      }
    }, onError: (error) => debugPrint('Message stream error: $error'));
  }

  void _handleIncomingMessage(String topic, Map<String, dynamic> message) {
    onMessageReceived?.call(message);
    _messageStreamController.add(message);
  }

  Future<void> publishControlCommand(
      String deviceId, String action, String state) async {
    await _publish(_controlTopicPrefix, {
      'id': deviceId,
      'action': action,
      'state': state,
    });
  }

  Future<void> publish(String topic, Map<String, dynamic> message) async {
    await _publish(topic, message);
  }

  Future<void> _publish(String topic, Map<String, dynamic> message) async {
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode(message));
      client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    } catch (e) {
      throw Exception('Failed to publish message: $e');
    }
  }

  Future<void> disconnect() async {
    await _messageStreamController.close();
    client?.disconnect();
  }

  MqttConnectionState get connectionState {
    return client?.connectionStatus?.state ?? MqttConnectionState.disconnected;
  }

  void unsubscribe(String topic) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      client!.unsubscribe(topic);
    }
  }
}
