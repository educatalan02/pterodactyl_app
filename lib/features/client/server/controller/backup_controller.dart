import 'package:dartactyl/dartactyl.dart';
import 'package:get/get.dart';

class BackupController extends GetxController {
  var backups = <Backup>[].obs;
  @override
  void onInit() {
    super.onInit();

    fetchBackups();
  }

  void fetchBackups() async {}

  void createBackup() async {}

  void deleteBackup() async {}

  void restoreBackup(Backup backup) async {}
}
