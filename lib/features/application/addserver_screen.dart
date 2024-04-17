import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pterodactyl_app/data/panel.dart';
import 'package:pterodactyl_app/features/application/controller/panelcontroller.dart';
import 'package:sqflite/sqflite.dart';



class AddServer extends StatelessWidget {
  AddServer({super.key});

  Future<void> insertPanel(Panel server) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'panel_apis.db'),
    );

    await db.insert(
      'panel_apis',
      server.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  final TextEditingController _panelController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _serverIdController = TextEditingController();

  final PanelController serverController = Get.find();

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
                labelText: 'Panel Alias',
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
                var panel = Panel(
                    panelUrl: _panelController.text,
                    apiKey: _apiKeyController.text,
                    name: _serverIdController.text);

                await insertPanel(panel);

                serverController.fetchPanels();
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
