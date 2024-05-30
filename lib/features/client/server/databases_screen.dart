import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/server/controller/databases_controller.dart';
import 'package:flutter/services.dart';

class DatabasesScreen extends StatelessWidget {
  final ServerState server;
  const DatabasesScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DatabasesController(server));

    return Scaffold(
        appBar: AppBar(
          title: Text('databases'.tr),
        ),
        body: Obx(() {
          if (controller.databases.isEmpty) {
            return Center(child: Text('no_databases'.tr));
          } else {
            return ListView.builder(
              itemCount: controller.databases.length,
              itemBuilder: (context, index) {
                final database = controller.databases[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.storage),
                    title: Text(database.name),
                    subtitle:
                        Text("${database.host.address}:${database.host.port}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: Text('delete_database'.tr),
                          content: Text('delete_database_confirm'
                              .trParams({'name': database.name}).toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                controller.deleteDatabase(database.id);
                                Get.back();
                                Get.snackbar('database_deleted'.tr,
                                    'database_deleted_message'.tr);
                              },
                              child: Text('delete'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('cancel'.tr),
                            ),
                          ],
                        ));
                      },
                    ),
                    onTap: () {
                      Get.dialog(AlertDialog(
                        title: Text('database_details'.tr),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textClipboard('database', database.name),
                            _textClipboard('host', database.host.address),
                            _textClipboard(
                                'port', database.host.port.toString()),
                            _textClipboard('username', database.username),
                            _textClipboard('password', database.password!),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('close'.tr),
                          ),
                        ],
                      ));
                    },
                  ),
                );
              },
            );
          }
        }));
  }

  Widget _textClipboard(String text, String text2) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text2));
        Get.snackbar('copied'.tr, 'copied_to_clipboard'.tr,
            backgroundColor: Colors.white60);
      },
      child: Text('${text.tr}: $text2'),
    );
  }
}
