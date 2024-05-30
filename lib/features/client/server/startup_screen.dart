import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/server/controller/startup_controller.dart';

class StartupScreen extends StatelessWidget {
  final ServerState server;
  const StartupScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StartupController(server));
    return Scaffold(
      appBar: AppBar(
        title: Text('startup'.tr),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
