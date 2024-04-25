import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/panel.dart';

import 'package:dartactyl/dartactyl.dart';
import 'package:pterodactyl_app/features/client/controller/servercontroller.dart';
import 'package:pterodactyl_app/features/client/server_screen.dart';
import 'package:pterodactyl_app/features/client/widgets/server_fileexplorer.dart';

import 'package:pterodactyl_app/features/client/widgets/serverpowerbutton.dart';

class Servers extends StatefulWidget {
  final Panel panel;
  const Servers({super.key, required this.panel});

  @override
  State<Servers> createState() => _ServersState();
}

class _ServersState extends State<Servers> {
  PteroClient getClient() {
    return PteroClient.generate(
        url: widget.panel.panelUrl, apiKey: widget.panel.apiKey);
  }

  late ServerController controller;
  @override
  void initState() {
    super.initState();

    controller = Get.put(ServerController(widget.panel));

    controller.loadServers();
  }

  @override
  Widget build(BuildContext context) {
    var client = getClient();

    final ServerController controller = Get.put(ServerController(widget.panel));
    controller.loadServers();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.panel.name),
      ),
      body: FutureBuilder<FractalListMeta<Server, PaginatedMeta>>(
        future: client.listServers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Obx(() {
              return ListView.builder(
                itemCount: controller.servers.length,
                itemBuilder: (context, index) {
                  var server = controller.servers[index];

                  return Card(
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.star_rate),
                      ),
                      trailing: ServerPowerButton(
                          server: server,
                          client: client,
                          controller: controller),
                      title: Text(
                        server.server.name,
                      ),
                      onTap: () {
                        Get.to(() => ServerScreen(server: server));
                      },
                    ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }
}
