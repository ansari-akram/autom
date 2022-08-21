// ignore_for_file: avoid_print
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'server_comms.dart';

Future<MqttServerClient> connect(String uClient) async {
  MqttServerClient client =
  MqttServerClient.withPort('sweet-tweet.in', uClient, 1883);

  final connMessage = MqttConnectMessage()
      .authenticateAs('autom2022', 'autom2023')
      .startClean()
      .withWillQos(MqttQos.atMostOnce);

  client.connectionMessage = connMessage;

  try {
    await client.connect();
  } catch (e) {
    client.disconnect();
  }

  return client;
}

void toggleOnOff(String uID, String topic, String payLoad, String localIP) async {
  try {
    MqttServerClient client = await connect(uID);

    String pubTopic = "autom";
    final builder = MqttClientPayloadBuilder();
    builder.addString(payLoad);
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  } catch (e) {
    toggleLocalOnOff(localIP);
  }
}
