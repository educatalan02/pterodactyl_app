import 'package:dartactyl/dartactyl.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:logger/logger.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class SchedulesController extends GetxController {
  final ServerState server;
  SchedulesController(this.server);

  PteroClient get client => PteroClient.generate(
      url: server.panel.panelUrl, apiKey: server.panel.apiKey);

  var schedules = <ServerSchedule>[].obs;

  bool onlyWhenOnline = false;
  bool isActive = false;

  void toggleOnlyWhenOnline() {
    onlyWhenOnline = !onlyWhenOnline;
    update();
  }

  void toggleIsActive() {
    isActive = !isActive;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSchedules();
  }

  void fetchSchedules() async {
    final result = await client.listSchedules(
      serverId: server.server.uuid,
    );

    schedules.value = result.data.map((e) => e.serverSchedule).toList();

    Logger().d(schedules);
  }

  void createSchedule(RequestSchedule schedule) async {
    await client.createSchedule(schedule, serverId: server.server.uuid);
    fetchSchedules();
  }

  void deleteSchedule(int scheduleId) async {
    await client.deleteSchedule(
      serverId: server.server.uuid,
      scheduleId: scheduleId,
    );
    fetchSchedules();
  }
}
