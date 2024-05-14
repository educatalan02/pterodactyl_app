import 'package:dartactyl/dartactyl.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:logger/logger.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class DatabasesController extends GetxController {
  final ServerState server;
  DatabasesController(this.server);

  PteroClient get client => PteroClient.generate(
      url: server.panel.panelUrl, apiKey: server.panel.apiKey);

  var databases = <ServerDatabase>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDatabases();
  }

  void fetchDatabases() async {
    final result = await client.listServerDatabases(
      serverId: server.server.uuid,
      include: ServerDatabasesIncludes(includePassword: true),
    );
    databases.value = result.data.map((e) => e.serverDatabase).toList();

    Logger().d(databases);
  }

  void deleteDatabase(String databaseId) async {
    await client.deleteDatabase(
      serverId: server.server.uuid,
      databaseId: databaseId,
    );
    fetchDatabases();
  }
}
