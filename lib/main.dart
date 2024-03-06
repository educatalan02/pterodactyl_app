import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get/get.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:pterodactyl_app/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() async {
  // Open the database and store the reference.

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

  runApp(
    GetMaterialApp(
      home: const MainMenu(),
      initialRoute: '/',
      defaultTransition: Transition.native,
      translations: AppTranslations(),
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: [
        GetPage(name: '/', page: () => const MainMenu()),
        GetPage(name: '/addserver', page: () => AddServer()),
      ],
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      themeMode: ThemeMode.light,
    ),
    // get thememode from shared preferences
  );
}
