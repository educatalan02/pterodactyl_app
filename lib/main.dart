import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:pterodactyl_app/features/application/addserver_screen.dart';
import 'package:pterodactyl_app/features/application/menu_screen.dart';
import 'package:pterodactyl_app/features/application/splash_screen.dart';
import 'package:pterodactyl_app/features/application/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await deleteDatabase(join(await getDatabasesPath(), 'servers.db'));

  openDatabase(
    join(await getDatabasesPath(), 'panel_apis.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE panel_apis(id INTEGER PRIMARY KEY AUTOINCREMENT, panel TEXT, apiKey TEXT, name TEXT)',
      );
    },
    version: 1,
  );
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      home: const MainMenu(),
      initialRoute: '/',
      defaultTransition: Transition.fade,
      translations: AppTranslations(),
      locale: GetStorage().read('language') != null
          ? Locale(GetStorage().read('language'))
          : const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/addserver', page: () => AddServer()),
      ],
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xff4355b9),
          primaryContainer: Color(0xffdee0ff),
          secondary: Color.fromARGB(255, 82, 130, 218),
          secondaryContainer: Color(0xffd8e2ff),
          tertiary: Color(0xff537577),
          tertiaryContainer: Color(0xffa9d4d6),
          appBarColor: Color(0xff3c64ae),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          appBarBackgroundSchemeColor: SchemeColor.onSecondaryContainer,
          appBarScrolledUnderElevation: 5.0,
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xffe2e4ff),
          primaryContainer: Color(0xff5f6ec3),
          secondary: Color(0xffdde6ff),
          secondaryContainer: Color(0xff597bba),
          tertiary: Color(0xffb5dadc),
          tertiaryContainer: Color(0xff6c898b),
          appBarColor: Color(0xff597bba),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          appBarBackgroundSchemeColor: SchemeColor.primaryContainer,
          appBarScrolledUnderElevation: 5.0,
        ),
        keyColors: const FlexKeyColors(
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      themeMode: GetStorage().read('isDarkMode') == true
          ? ThemeMode.dark
          : ThemeMode.light,
    ),
  );
}
