import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pterodactyl_app/features/application/addserver_screen.dart';
import 'package:pterodactyl_app/features/application/menu_screen.dart';
import 'package:pterodactyl_app/features/application/splash_screen.dart';
import 'package:pterodactyl_app/features/application/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await deleteDatabase(join(await getDatabasesPath(), 'servers.db'));

  openDatabase(
    join(await getDatabasesPath(), 'panel_apis.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE panel_apis(id INTEGER PRIMARY KEY AUTOINCREMENT, panel TEXT, apiKey TEXT, name TEXT)',
      );
    },
    version: 1,
  );
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      home: const MainMenu(),
      initialRoute: '/',
      defaultTransition: Transition.leftToRightWithFade,
      translations: AppTranslations(),
      locale: GetStorage().read('language') != null
          ? Locale(GetStorage().read('language'))
          : const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/addserver', page: () => AddServer()),
      ],
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.blueM3),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.blueM3),
      themeMode: GetStorage().read('isDarkMode') == true
          ? ThemeMode.dark
          : ThemeMode.light,
    ),
  );
}
