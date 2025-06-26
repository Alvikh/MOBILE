import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> message);
typedef OnConnectionStatusChanged = void Function(MqttConnectionState state);

class MqttService {
  final MqttServerClient client;
  final String monitoringTopic = 'iot/monitoring';
  final String controlTopicPrefix = 'iot/control/';
  final OnMessageReceived? onMessageReceived;
  final OnConnectionStatusChanged? onConnectionStatusChanged;

  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  MqttService({
    required String broker,
    this.onMessageReceived,
    this.onConnectionStatusChanged,
  }) : client = MqttServerClient(
            broker, 'flutter_client_${DateTime.now().millisecondsSinceEpoch}') {
    _setupClient();
  }

  void _setupClient() {
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.pongCallback = _onPong;

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
  }

  Future<bool> connect() async {
    try {
      await client.connect();
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        debugPrint('✅ MQTT Connected');
        _subscribeToTopics();
        _listenForMessages();
        onConnectionStatusChanged?.call(MqttConnectionState.connected);
        return true;
      }
      debugPrint('❌ MQTT Failed to connect: ${client.connectionStatus!.state}');
      onConnectionStatusChanged?.call(client.connectionStatus!.state);
      return false;
    } catch (e) {
      debugPrint('MQTT Connection Exception: $e');
      client.disconnect();
      onConnectionStatusChanged?.call(MqttConnectionState.disconnected);
      return false;
    }
  }

  void _onConnected() {
    debugPrint('✅ MQTT Client Connected');
  }

  void _onDisconnected() {
    debugPrint('❌ MQTT Client Disconnected');
    onConnectionStatusChanged?.call(MqttConnectionState.disconnected);
  }

  void _onSubscribed(String topic) {
    debugPrint('🔔 Subscribed to $topic');
  }

  void _onPong() {
    debugPrint('🏓 Pong received');
  }

  void _subscribeToTopics() {
    client.subscribe(monitoringTopic, MqttQos.atLeastOnce);
  }

  void _listenForMessages() {
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final payload = message.payload as MqttPublishMessage;
        final topic = message.topic;
        final content =
            MqttPublishPayload.bytesToStringAsString(payload.payload.message);

        try {
          final jsonData = jsonDecode(content);
          _handleIncomingMessage(topic, jsonData);
        } catch (e) {
          debugPrint(
              'Error parsing message from topic "$topic": $e, content: "$content"');
        }
      }
    });
  }

  void _handleIncomingMessage(String topic, Map<String, dynamic> message) {
    if (topic == monitoringTopic) {
      onMessageReceived?.call(message);
      _messageStreamController.add(message);
    }
  }

  Future<void> publishControlCommand(String deviceId, String command) async {
    final topic = '$controlTopicPrefix$deviceId';
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(
        {'command': command, 'timestamp': DateTime.now().toIso8601String()}));

    try {
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      debugPrint('📤 Published command "$command" to $topic');
    } catch (e) {
      debugPrint('Error publishing command: $e');
      throw Exception('Failed to publish command');
    }
  }

  Future<void> publish(String topic, Map<String, dynamic> message) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(message));

    try {
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      debugPrint('📤 Published message to "$topic": ${jsonEncode(message)}');
    } catch (e) {
      debugPrint('Error publishing to "$topic": $e');
      throw Exception('Failed to publish message');
    }
  }

  Future<void> disconnect() async {
    _messageStreamController.close();
    client.disconnect();
  }

  MqttConnectionState get connectionState =>
      client.connectionStatus?.state ?? MqttConnectionState.disconnected;
}
