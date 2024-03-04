import 'package:pterodactyl_app/presentation/screens/screens.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider(this._themeData);

  getTheme() => _themeData;
  bool isDark() => _themeData == ThemeData.dark();

  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}