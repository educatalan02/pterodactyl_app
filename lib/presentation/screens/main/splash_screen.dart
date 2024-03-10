import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(

      backgroundColor: const Color.fromARGB(0, 126, 206, 255),
      childWidget: SizedBox(
        width: 200,
        child: Image.asset('assets/logo.png'),
      ),

      nextScreen: const MainMenu(),
    );
    
  }
}