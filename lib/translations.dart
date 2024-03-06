import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'settings': 'Settings',
          'darkMode': 'Dark Mode',
          'language': 'Language',
          'goodbye': 'Goodbye',
          // Add more English translations here
        },
        'es_ES': {
          'settings': 'Ajustes',
          'darkMode': 'Modo Oscuro',
          'language': 'Idioma',
          'goodbye': 'Adiós',
          // Add more Spanish translations here
        },
        // Add more languages here
      };
}
