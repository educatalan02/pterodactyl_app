import 'package:get/get.dart';

import 'package:path/path.dart';
import 'package:pterodactyl_app/data/panel.dart';
import 'package:sqflite/sqflite.dart';

class PanelController extends GetxController {
  var panels = <Panel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPanels();
  }

  void fetchPanels() async {
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'panel_apis.db'),
    );

    final List<Map<String, dynamic>> maps = await db.query('panel_apis');

    panels.value = List.generate(maps.length, (i) {
      return Panel(
        panelUrl: maps[i]['panel'],
        apiKey: maps[i]['apiKey'],
        name: maps[i]['name'],
      );
    });
  }
}
