import 'package:flutter/material.dart';
import '../mqtt/mqtt_service.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _mqttService = MqttService();

  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: "1883");
  final _clientIdController = TextEditingController(text: "flutter-client");
  final _topicController = TextEditingController();
  final _payloadController = TextEditingController();

  String _status = "Disconnected";

  Future<void> _connect() async {
    final connected = await _mqttService.connect(
      host: _hostController.text,
      port: int.parse(_portController.text),
      clientId: _clientIdController.text,
    );

    setState(() {
      _status = connected ? "Connected" : "Failed";
    });
  }

  void _publish(){
    _mqttService.publish(_topicController.text, _payloadController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple MQTT Client")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Status: $_status"),
            const SizedBox(height: 16),

            TextField(
              controller: _hostController,
              decoration: const InputDecoration(labelText: "Broker Host"),
            ),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(labelText: "Port"),
            ),
            TextField(
              controller: _clientIdController,
              decoration: const InputDecoration(labelText: "Client ID"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
                onPressed: _connect,
                child: const Text("Connect")
            ),

            const Divider(height: 32),

            TextField(
              controller: _topicController,
              decoration: const InputDecoration(labelText: "Topic"),
            ),
            TextField(
              controller: _payloadController,
              decoration: const InputDecoration(labelText: "Payload"),
              maxLines: 8,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
                onPressed: _publish,
                child: const Text("Publish"),
            ),
          ],
        ),
      ),
    );
  }
}

