import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/server/backups_screen.dart';
import 'package:pterodactyl_app/features/client/server/databases_screen.dart';
import 'package:pterodactyl_app/features/client/server/schedules_screen.dart';

class MoreActions extends StatelessWidget {
  final ServerState server;
  MoreActions({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('databases'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(() => DatabasesScreen(server: server));
                },
              ),
            ),
            /*Card(
              child: ListTile(
                trailing: const Icon(Icons.chevron_right),
                title: Text('schedules'.tr),
                onTap: () {
                  Get.to(() => SchedulesScreen(
                        server: server,
                      ));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('users'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearanceSettings()));
                },
              ),
            ),*/
            Card(
              child: ListTile(
                title: Text('backups'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(() => BackupsScreen(server: server));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('network'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearanceSettings()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('startup'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearanceSettings()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('settings'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearanceSettings()));
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('activity_logs'.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AppearanceSettings()));
                },
              ),
            ),
          ],
        ));
  }
}
