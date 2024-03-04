
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
        'CREATE TABLE servers(id INTEGER PRIMARY KEY AUTOINCREMENT, socket TEXT, panel TEXT, apiKey TEXT, serverId TEXT, name TEXT, optionalTag TEXT)',
      );
    },
    version: 1,
  );
  

  
  

  


  runApp(
    // get thememode from shared preferences

    


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
            theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
            themeMode: ThemeMode.dark,
            routes: {
              '/': (context) => const MainMenu(),
              '/addserver': (context) => AddServer(),
            },
          );
        
      
    
  }

}
