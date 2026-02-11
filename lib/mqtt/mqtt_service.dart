import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<bool> connect({
    required String host,
    required int port,
    required String clientId,
  }) async {
    _client = MqttServerClient(host, clientId);
    _client!.port = port;
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 20;

    _client!.onConnected = () {
      print('MQTT Connected!');
    };

    _client!.onDisconnected = () {
      print('MQTT Disconnect');
    };

    try {
      await _client!.connect();
    } catch (e) {
      print('Connection error: $e');
      _client!.disconnect();
      return false;
    }

    return isConnected;
  }

  void disconnect() {
    _client?.disconnect();
  }

  void publish(String topic, String payload) {
    if (!isConnected) return;

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _client!.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }
}
