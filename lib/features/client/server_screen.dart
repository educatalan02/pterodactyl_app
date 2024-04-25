import 'package:flutter/material.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/widgets/file_explorer/server_fileexplorer.dart';

class ServerScreen extends StatelessWidget {
  const ServerScreen({super.key, required this.server});

  final ServerState server;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server'),
      ),
      body: ServerFileExplorer(
        server: server,
      ),
    );
  }
}
