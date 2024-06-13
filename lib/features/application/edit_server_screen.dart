import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pterodactyl_app/data/panel.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:sqflite/sqflite.dart';

class EditServerScreen extends StatelessWidget {
  EditServerScreen({super.key, required this.panel});
  final Panel panel;

  final TextEditingController _panelController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _serverIdController = TextEditingController();

  Future<void> savePanel(Panel panel) async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'panel_apis.db'),
    );

    await db.update(
      'panel_apis',
      panel.toMap(),
      where: 'id = ?',
      whereArgs: [panel.id],
    );
  }

  @override
  Widget build(BuildContext context) {
    _panelController.text = panel.panelUrl;
    _apiKeyController.text = panel.apiKey;
    _serverIdController.text = panel.name;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Panel'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  panel.panelUrl = _panelController.text;
                  panel.apiKey = _apiKeyController.text;
                  panel.name = _serverIdController.text;

                  Get.back();
                },
                child: Text('save'.tr),
              ),
            ],
          ),
        ));
  }
}
