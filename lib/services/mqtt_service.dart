import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionStatusChanged = void Function(MqttConnectionState state);

class MqttService {
  static const String _mqttBroker = 'broker.hivemq.com';
  static const int _mqttPort = 1883;
  late String topic;
  static const String _controlTopicPrefix = 'smartpower/device/control';

  final MqttServerClient client;
  final OnMessageReceived? onMessageReceived;
  final OnConnectionStatusChanged? onConnectionStatusChanged;

  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  MqttService({
    this.onMessageReceived,
    this.onConnectionStatusChanged,
    this.topic = 'iot/monitoring',
  }) : client = MqttServerClient(_mqttBroker, _generateClientId()) {
    _setupClient();
  }

  static String _generateClientId() {
    return 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _setupClient() {
    client.port = _mqttPort;
    client.keepAlivePeriod = 30; // Increased from 20 to 30 seconds
    client.logging(on: false);

    // Connection handlers
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.pongCallback = _onPong;

    // Connection message with Last Will and Testament
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillTopic('$client.clientIdentifier/status')
        .withWillMessage('offline')
        .withWillQos(MqttQos.atLeastOnce);
  }

  Future<bool> connect({int maxRetries = 3, int retryDelay = 2}) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        debugPrint('Connecting to MQTT broker (attempt ${attempts + 1})...');
        await client.connect();

        if (client.connectionStatus?.state == MqttConnectionState.connected) {
          debugPrint('✅ Successfully connected to $_mqttBroker:$_mqttPort');
          _subscribeToTopics();
          _listenForMessages();
          onConnectionStatusChanged?.call(MqttConnectionState.connected);
          return true;
        }
      } catch (e) {
        debugPrint('MQTT connection error: $e');
        await Future.delayed(Duration(seconds: retryDelay));
      }
      attempts++;
    }

    debugPrint('❌ Failed to connect after $maxRetries attempts');
    onConnectionStatusChanged?.call(MqttConnectionState.disconnected);
    return false;
  }

  void _onConnected() {
    debugPrint('MQTT connection established');
  }

  void _onDisconnected() {
    debugPrint('MQTT connection lost');
    onConnectionStatusChanged?.call(MqttConnectionState.disconnected);
  }

  void _onSubscribed(String topic) {
    debugPrint('Subscribed to topic: $topic');
  }

  void _onPong() {
    debugPrint('Ping response received');
  }

  void _subscribeToTopics() {
    client.subscribe(topic, MqttQos.atLeastOnce);
    debugPrint('Subscribed to monitoring topic: $topic');
  }

  void _listenForMessages() {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        try {
          final payload = message.payload as MqttPublishMessage;
          final topic = message.topic;
          final content =
              MqttPublishPayload.bytesToStringAsString(payload.payload.message);

          final jsonData = jsonDecode(content) as Map<String, dynamic>;
          _handleIncomingMessage(topic, jsonData);
        } catch (e) {
          debugPrint('Error processing message: $e');
        }
      }
    }, onError: (error) {
      debugPrint('Message stream error: $error');
    });
  }

  void _handleIncomingMessage(String topic, Map<String, dynamic> message) {
    if (topic == topic) {
      onMessageReceived?.call(message);
      _messageStreamController.add(message);
    }
  }

  Future<void> publishControlCommand(
      String deviceId, String action, String state) async {
    final topic = _controlTopicPrefix;
    final message = {
      'id': deviceId,
      'action': action, // e.g. "relay_control"
      'state': state, // "ON" or "OFF"
    };

    try {
      await _publish(topic, message);
      debugPrint('Published control command to $topic: ${jsonEncode(message)}');
    } catch (e) {
      debugPrint('Error publishing control command: $e');
      throw Exception('Failed to publish control command');
    }
  }

  Future<void> publish(String topic, Map<String, dynamic> message) async {
    await _publish(topic, message);
  }

  Future<void> _publish(String topic, Map<String, dynamic> message) async {
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(jsonEncode(message));

      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      debugPrint('Published to $topic: ${jsonEncode(message)}');
    } catch (e) {
      debugPrint('Publish error: $e');
      throw Exception('Failed to publish message: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await _messageStreamController.close();
      client.disconnect();
      debugPrint('Disconnected from MQTT broker');
    } catch (e) {
      debugPrint('Disconnection error: $e');
    }
  }

  MqttConnectionState get connectionState {
    return client.connectionStatus?.state ?? MqttConnectionState.disconnected;
  }
}
