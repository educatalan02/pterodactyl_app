import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pterodactyl_app/presentation/screens/main/splash_screen.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:pterodactyl_app/translations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // delete the database
  //await deleteDatabase(join(await getDatabasesPath(), 'servers.db'));

  // ignore: unused_local_variable
  final database = openDatabase(
    join(await getDatabasesPath(), 'servers.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE servers(id INTEGER PRIMARY KEY AUTOINCREMENT, socket TEXT, panel TEXT, apiKey TEXT, serverId TEXT, name TEXT, optionalTag TEXT)',
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
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      themeMode: GetStorage().read('isDarkMode') == true
          ? ThemeMode.dark
          : ThemeMode.light,
      
    ),
    // get thememode from shared preferences
  );
}
