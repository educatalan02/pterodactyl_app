import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:pterodactyl_app/translations.dart';

class AppSettingsController extends GetxController {
  RxBool isDarkMode = (Get.isDarkMode).obs;
  RxString language = (Get.locale?.languageCode ?? 'en').obs;
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
