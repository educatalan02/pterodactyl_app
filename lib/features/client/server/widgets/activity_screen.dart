import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/server/controller/activity_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityScreen extends StatelessWidget {
  final ServerState server;
  const ActivityScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityController(server));
    
    return Scaffold(
        appBar: AppBar(
          title: Text('activity_logs'.tr),
        ),
        body: Obx(() {
          return ListView.builder(
            itemCount: controller.activityLogs.length,
            itemBuilder: (context, index) {
              final log = controller.activityLogs[index];

              return Card(
                child: ListTile(
                  title: Text(
                      "${log.relationships?.actor?.attributes.username} -- ${log.event}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(timeago.format(log.timestamp)),
                      Text(log.properties['file'] ??
                          ''), // Añade tu nuevo widget aquí
                    ],
                  ),
                ),
              );
            },
          );
        }));
  }
}
