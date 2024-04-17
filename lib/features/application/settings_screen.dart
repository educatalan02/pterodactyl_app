import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsController extends GetxController {
  RxBool isDarkMode = (Get.isDarkMode).obs;
  RxString language = (Get.locale?.languageCode ?? 'en').obs;
  GetStorage box = GetStorage();

  @override
  void onInit() {
    isDarkMode.value = box.read('isDarkMode') ?? Get.isDarkMode;
    language.value = box.read('language') ?? Get.locale!.languageCode;
    super.onInit();
  }
}

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});
  AppSettingsController get _controller => Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: ListView(
        children: [
          Card(
            child: Obx(
              () => SwitchListTile(
                title: Text('darkMode'.tr),
                value: _controller.isDarkMode.value,
                onChanged: (bool value) {
                  _controller.isDarkMode.value = value;

                  _controller.box.write('isDarkMode', value);
                  Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
          ),
          // Language selector dropdown

          Card(
            child: Obx(
              () => ListTile(
                title: Text('language'.tr),
                trailing: DropdownButton<String>(
                  value: _controller.language.value,
                  onChanged: (String? languageCode) {
                    if (languageCode != null) {
                      _controller.language.value = languageCode;

                      _controller.box.write('language', languageCode);
                      Get.updateLocale(Locale(languageCode));
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text('Spanish'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
