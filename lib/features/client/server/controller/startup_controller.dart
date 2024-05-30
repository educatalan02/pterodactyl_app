import 'package:dartactyl/dartactyl.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class StartupController extends GetxController {
  final ServerState server;
  StartupController(this.server);
  PteroClient get client => PteroClient.generate(
      url: server.panel.panelUrl, apiKey: server.panel.apiKey);

  List<EggVariable> eggVariables = <EggVariable>[].obs;

  void getStartupParameters() {
    client.getStartup(serverId: server.server.uuid).then((value) =>
        eggVariables = value.data.map((e) => e.eggVariable).toList());

    for (var eggVariable in eggVariables) {
      Logger().d(eggVariable);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getStartupParameters();
  }
}
