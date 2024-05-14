import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class BackupsScreen extends StatelessWidget {
  final ServerState server;
  const BackupsScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('backups'.tr),
        ),
        body: Center(
          child: Text('backups'.tr),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(_buildDialog());
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget _buildDialog() {
    return Column(
      children: [
        const Text('Create a new backup'),
        const TextField(
          decoration: InputDecoration(labelText: 'Backup name'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Backup description'),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Create backup'))
      ],
    );
  }
}
