import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/features/application/menu_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: const Color.fromARGB(0, 214, 233, 245),
      childWidget: SizedBox(
        width: 200,
        child: Image.asset('assets/logo.png'),
      ),
      nextScreen: const MainMenu(),
    );
  }
}
