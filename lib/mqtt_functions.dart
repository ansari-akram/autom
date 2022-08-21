// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'dart:async';


Future<MqttServerClient> connect(String uClient) async {
  MqttServerClient client =
  MqttServerClient.withPort('iot.reyax.com', uClient, 1883);

  final connMessage = MqttConnectMessage()
      .authenticateAs('kXRzxQSTPB', 'XUAppSwWNv')
      .withWillQos(MqttQos.atLeastOnce);

  client.connectionMessage = connMessage;
  try {
    await client.connect();
  } catch (e) {
    client.disconnect();
  }

  return client;
}

void turnOn() async {
  String _uuid = 'kj;klasdjf';
  MqttServerClient client = await connect(_uuid);

  const pubTopic = '222304-001';
  final builder = MqttClientPayloadBuilder();
  builder.addString('1_OFF');
  client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
}