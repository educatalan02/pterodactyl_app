import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pterodactyl_app/models/server.dart';
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> fetchSocketUrl(
      String panelUrl, String apiKey, String serverId) async {
    // fetch the socket url from the panel
    // and return the socket url
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
        // Si el servidor devuelve una respuesta OK, parsea el JSON.
        print(jsonDecode(response.body));
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
    // fetch the server details from the panel
    // and return a server object

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

  // controller for the text field
  final TextEditingController _panelController = TextEditingController();

  final TextEditingController _apiKeyController = TextEditingController();

  final TextEditingController _serverIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Server'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _panelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Panel URL',
              ),
            ),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'API Key',
              ),
            ),
            TextField(
              controller: _serverIdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server ID',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // save the server details

                final server = await fetchServerDetails(_panelController.text,
                    _apiKeyController.text, _serverIdController.text);

                insertServer(server);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
