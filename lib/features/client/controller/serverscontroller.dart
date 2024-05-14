import 'dart:async';

import 'package:dartactyl/dartactyl.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pterodactyl_app/data/panel.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class ServerController extends GetxController {
  RxList<ServerState> servers = <ServerState>[].obs;
  var favoriteServers = <ServerState>[].obs;
  Timer? timer;

  final Panel panel;

  late PteroClient client =
      PteroClient.generate(url: panel.panelUrl, apiKey: panel.apiKey);

  void removeFromFavorites(ServerState server) {
    favoriteServers.remove(server);
    servers.add(server);
  }

  void addToFavorites(ServerState server) {
    servers.remove(server);
    favoriteServers.add(server);
  }

  void refreshServerState(Server server) async {
    var response = await client.getServerResources(serverId: server.uuid);
    updateServerState(server, response.attributes.currentState);
  }

  void updateServerState(Server server, ServerPowerState newState) {
    int index = servers.indexWhere((s) => s.server.uuid == server.uuid);
    if (index != -1) {
      servers[index] = ServerState(
          server: server, state: newState, panel: servers[index].panel);
    }

    int favoriteIndex =
        favoriteServers.indexWhere((s) => s.server.uuid == server.uuid);
    if (favoriteIndex != -1) {
      favoriteServers[favoriteIndex] = ServerState(
          server: server,
          state: newState,
          panel: favoriteServers[favoriteIndex].panel);
    }
  }

  ServerController(this.panel);

  void loadServers() async {
    var response = await client.listServers();
    var serverStates = await Future.wait(response.data.map((server) async {
      if (favoriteServers
          .any((favServer) => favServer.server.uuid == server.server.uuid)) {
        return null;
      }
      var state = await client.getServerResources(serverId: server.server.uuid);
      return ServerState(
          server: server.server,
          state: state.attributes.currentState,
          panel: panel);
    }).toList());

    servers.value = serverStates.whereType<ServerState>().toList();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();

    saveFavoriteServers();
  }

  @override
  void onInit() {
    super.onInit();
    loadFavoriteServers();
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      for (var server in servers) {
        refreshServerState(server.server);
      }
    });
  }

  void saveFavoriteServers() {
    final storage = GetStorage();
    storage.write('favoriteServers',
        favoriteServers.map((e) => e.server.toJson()).toList());
  }

  void loadFavoriteServers() {
    final storage = GetStorage();

    storage.read('favoriteServers')?.forEach((server) async {
      var state = await getServerState(Server.fromJson(server));
      favoriteServers.add(ServerState(
          server: Server.fromJson(server), state: state, panel: panel));
    });
  }

  Future<ServerPowerState> getServerState(Server server) async {
    var state = await client.getServerResources(serverId: server.uuid);
    return state.attributes.currentState;
  }
}
