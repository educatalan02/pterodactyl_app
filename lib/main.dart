
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/config/theme/app_theme.dart';
import 'package:pterodactyl_app/presentation/screens/main/addserver.dart';
import 'package:pterodactyl_app/presentation/screens/mainmenu.dart';
import 'package:pterodactyl_app/presentation/screens/providers/server_settings_provider.dart';
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
        'CREATE TABLE servers(socket TEXT, panel TEXT, apiKey TEXT, serverId TEXT, name TEXT, optionalTag TEXT)',
      );
    },
    version: 1,
  );
  runApp(

     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerSettingsProvider()),
      ] ,
      child: const MyApp(),  
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pterodactyl App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routes: {
        '/': (context) => const MainMenu(),
        '/addserver': (context) => AddServer(),
      },
    );
  }
}
