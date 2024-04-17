import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/features/application/addserver_screen.dart';
import 'package:pterodactyl_app/features/application/settings_screen.dart';
import 'package:pterodactyl_app/features/application/controller/panelcontroller.dart';
import 'package:pterodactyl_app/features/client/servers_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final PanelController serverController = Get.put(PanelController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pterodactyl App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const AppSettings());
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: serverController.panels.length,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: 10),
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                child: Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.cloud,
                    ),
                    title: Text(
                      serverController.panels[index].name,
                    ),
                    subtitle: Text(
                      serverController.panels[index].panelUrl,
                    ),
                    onTap: () {
                      Get.to(() => Servers(
                            panel: serverController.panels[index],
                          ));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => AddServer());
          serverController
              .fetchPanels(); // Actualiza la lista de servidores después de añadir un nuevo servidor
        },
      ),
    );
  }
}
