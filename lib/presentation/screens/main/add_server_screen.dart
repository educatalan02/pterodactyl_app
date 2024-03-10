import 'dart:convert';

import 'package:get/get.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:pterodactyl_app/entities/model/server.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

class AddServer extends StatelessWidget {
  AddServer({super.key});

  Future<void> insertServer(Server server) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'servers.db'),
    );

    await db.insert(
      'servers',
      server.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<String> fetchSocketUrl(
      String panelUrl, String apiKey, String serverId) async {
    final response = await http.get(
      Uri.parse('$panelUrl/api/client/servers/$serverId/websocket'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);
        return data["data"]["socket"];
      case 401:
        throw Exception('Unauthorized request. Check your API key.');
      case 404:
        throw Exception('Server not found. Check your server ID.');
      default:
        throw Exception(
            'Failed to load server details. Status code: ${response.statusCode}');
    }
  }

  Future<Server> fetchServerDetails(
      String panelUrl, String apiKey, String serverId) async {
    var response = await http.get(
      Uri.parse('$panelUrl/api/client/servers/$serverId'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    Server server;
    if (response.statusCode == 200) {
      server = Server(
        panelUrl: panelUrl,
        apiKey: apiKey,
        serverId: serverId,
        socketUrl: await fetchSocketUrl(panelUrl, apiKey, serverId),
        name: jsonDecode(response.body)['attributes']['name'],
      );
    } else {
      throw Exception(
          'Failed to load server details. Status code: ${response.statusCode}');
    }

    return server;
  }

  final TextEditingController _panelController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _serverIdController = TextEditingController();

  final ServerController serverController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Server'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _panelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Panel URL',
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Key',
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _serverIdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server ID',
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background
                foregroundColor: Colors.white, // foreground
              ),
              onPressed: () async {
                final server = await fetchServerDetails(_panelController.text,
                    _apiKeyController.text, _serverIdController.text);

                await insertServer(server);

                serverController.fetchServers();
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
