
import 'package:pterodactyl_app/presentation/screens/providers/theme_provider.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';
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
        'CREATE TABLE servers(socket TEXT, panel TEXT, apiKey TEXT, serverId TEXT, name TEXT, optionalTag TEXT)',
      );
    },
    version: 1,
  );
  

  final prefs = SharedPreferences.getInstance().then((x) => x.getBool("isDarkMode"));

  

  


  runApp(
    // get thememode from shared preferences

    


     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerSettingsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeData.dark())),
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
    
    return FutureBuilder<bool>(
      future: getThemeMode(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Muestra un indicador de carga mientras espera
        } else {
          return MaterialApp(
            title: 'Pterodactyl App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme(colorSeleccionado: 1, isDarkMode: snapshot.data ?? false).getTheme(),
            routes: {
              '/': (context) => const MainMenu(),
              '/settings': (context) => const AppSettings(),
              '/addserver': (context) => AddServer(),
            },
          );
        }
      },
    );
  }

  Future<bool> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkTheme') ?? false;
  }
}
