import 'package:dartactyl/dartactyl.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class ActivityController extends GetxController {
  final ServerState server;

  final activityLogs = <ActivityLog>[].obs;

  PteroClient get client => PteroClient.generate(
      url: server.panel.panelUrl, apiKey: server.panel.apiKey);

  ActivityController(this.server);
  @override
  void onInit() {
    super.onInit();
    fetchActivity();
  }

  void fetchActivity() {
    client
        .getServerActivity(
            serverId: server.server.uuid,
            perPage: 500,
            sort: ActivityLogSort.sortByTimestamp,
            include: ActivityLogsIncludes(includeActor: true))
        .then((value) {
      activityLogs.value = value.data.map((e) => e.attributes).toList();

      Logger().d(activityLogs);

    });
  }
}
