import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/panel.dart';

import 'package:dartactyl/dartactyl.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/controller/servercontroller.dart';
import 'package:pterodactyl_app/features/client/server_screen.dart';

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
              return Column(
                children: [
                  const SizedBox(height: 6),
                  ...controller.favoriteServers.map(
                      (server) => buildServerCard(server, client, controller)),
                  if (controller.favoriteServers.isNotEmpty)
                    const Divider(
                      thickness: 1,
                      height: 14,
                    ),
                  ...controller.servers
                      .where((s) => !controller.favoriteServers.contains(s))
                      .map((server) =>
                          buildServerCard(server, client, controller)),
                ],
              );
            });
          }
        },
      ),
    );
  }
}

Widget buildServerCard(
    ServerState server, PteroClient client, ServerController controller) {
  return Card(
    child: ListTile(
      leading: IconButton(
        onPressed: () {
          if (controller.favoriteServers.contains(server)) {
            controller.removeFromFavorites(server);
          } else {
            controller.addToFavorites(server);
          }
        },
        icon: Icon(
          controller.favoriteServers.contains(server)
              ? Icons.star
              : Icons.star_border,
          color: controller.favoriteServers.contains(server)
              ? Colors.yellow
              : null,
        ),
      ),
      trailing: ServerPowerButton(
          server: server, client: client, controller: controller),
      title: Text(
        server.server.name,
      ),
      onTap: () {
        Get.to(() => ServerScreen(server: server));
      },
    ),
  );
}
