import 'dart:async';

import 'package:dartactyl/dartactyl.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class ServerController extends GetxController {
  RxList<ServerState> servers = <ServerState>[].obs;
  Timer? timer;

  void refreshServerState(Server server) async {
    var response = await client.getServerResources(serverId: server.uuid);
    updateServerState(server, response.attributes.currentState);
  }

  void updateServerState(Server server, ServerPowerState newState) {
    int index = servers.indexWhere((s) => s.server.uuid == server.uuid);
    if (index != -1) {
      servers[index] = ServerState(server: server, state: newState);
    }
  }

  final PteroClient client;

  ServerController(this.client);

  void loadServers() async {
    var response = await client.listServers();
    servers.value = await Future.wait(response.data.map((server) async {
      var state = await client.getServerResources(serverId: server.server.uuid);
      return ServerState(
          server: server.server, state: state.attributes.currentState);
    }).toList());
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      for (var server in servers) {
        refreshServerState(server.server);
      }
    });
  }
}
