import 'package:dartactyl/dartactyl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/server/controller/schedules_controller.dart';

class SchedulesScreen extends StatelessWidget {
  final ServerState server;
  const SchedulesScreen({super.key, required this.server});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchedulesController(server));
    return Scaffold(
      appBar: AppBar(
        title: Text('schedules'.tr),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController minuteController = TextEditingController();
          TextEditingController hourController = TextEditingController();
          TextEditingController dayOfWeekController = TextEditingController();
          TextEditingController dayOfMonthController = TextEditingController();
          TextEditingController monthController = TextEditingController();
          bool onlyWhenOnline = false;
          bool isActive = false;

          Get.dialog(
            AlertDialog.adaptive(
              title: Text('create_schedule'.tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: Text('schedule_only_when_online'.tr),
                      value: controller.onlyWhenOnline,
                      onChanged: (value) {
                        controller.toggleOnlyWhenOnline();
                      },
                    ),
                    SwitchListTile(
                      title: Text('schedule_is_active'.tr),
                      value: controller.isActive,
                      onChanged: (value) {
                        controller.toggleIsActive();
                      },
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'schedule_name'.tr,
                      ),
                    ),
                    TextFormField(
                      controller: minuteController,
                      decoration: InputDecoration(
                        labelText: 'minute'.tr,
                      ),
                    ),
                    TextFormField(
                      controller: hourController,
                      decoration: InputDecoration(
                        labelText: 'hour'.tr,
                      ),
                    ),
                    TextFormField(
                      controller: dayOfWeekController,
                      decoration: InputDecoration(
                        labelText: 'day_of_week'.tr,
                      ),
                    ),
                    TextFormField(
                      controller: dayOfMonthController,
                      decoration: InputDecoration(
                        labelText: 'day_of_month'.tr,
                      ),
                    ),
                    TextFormField(
                      controller: monthController,
                      decoration: InputDecoration(
                        labelText: 'month'.tr,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('cancel'.tr),
                ),
                TextButton(
                  onPressed: () {
                    RequestSchedule schedule = RequestSchedule(
                      onlyWhenOnline: onlyWhenOnline,
                      name: nameController.text,
                      isActive: isActive,
                      minute: minuteController.text,
                      hour: hourController.text,
                      dayOfWeek: dayOfWeekController.text,
                      dayOfMonth: dayOfMonthController.text,
                      month: monthController.text,
                    );

                    controller.createSchedule(schedule);

                    // Aquí puedes manejar el cronograma ingresado por el usuario
                    Get.back();
                  },
                  child: Text('create'.tr),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
