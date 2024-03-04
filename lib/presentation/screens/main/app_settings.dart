import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pterodactyl_app/presentation/screens/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(

       body: Center(child:Switch(
        // This bool value toggles the switch.
        value: light,
        activeColor: Colors.red,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.

          setState((){

            

            
            light = value;

            Future<bool> prefs = SharedPreferences.getInstance().then((x) => x.setBool("isDarkTheme", value));
            
          });
        },
      ),)
      )



    );
  }
}