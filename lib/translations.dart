import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'settings': 'Settings',
          'darkMode': 'Dark Mode',
          'language': 'Language',
          'goodbye': 'Goodbye',
          'console': 'Console',
          'save': 'Save',
          'type_a_command': 'Type a command here...',
          'server_starting': 'Server is starting...',
          'server_stopping': 'Server is stopping...',
          // Add more English translations here
        },
        'es_ES': {
          'settings': 'Ajustes',
          'darkMode': 'Modo Oscuro',
          'language': 'Idioma',
          'goodbye': 'Adiós',
          'console': 'Consola',
          'save': 'Guardar',
          'type_a_command': 'Escribe un comando aquí...',
          'server_starting': 'El servidor se está iniciando...',
          'server_stopping': 'El servidor se está deteniendo...',
          // Add more Spanish translations here
        },
        // Add more languages here
      };
}
