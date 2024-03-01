
import 'package:flutter/material.dart';

class AppTheme{
  static const colorList = [

    // get color by RGB
    Color.fromRGBO(32, 30, 31, 1),
    Color.fromRGBO(255, 64,0, 1),
    Color.fromRGBO(42, 43, 42, 1),
    Color.fromRGBO(254, 239, 221, 1),
    Color.fromRGBO(80, 178, 192, 1),
    Color.fromRGBO(58, 190, 255, 1)


  ];

  static const primaryColor = Color.fromRGBO(46,94, 170, 1);
  static const secondaryColor = Color.fromRGBO(255, 64,0, 1);
  static const backgroundColor = Color.fromRGBO(42, 43, 42, 1);
  static const accentColor = Color.fromRGBO(254, 239, 221, 1);
  static const buttonColor = Color.fromRGBO(255, 255, 255, 1);


  final bool darkMode;

AppTheme({this.darkMode = false});


ThemeData getTheme() => ThemeData(
  primaryColor: accentColor,
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: accentColor,
      fontSize: 24,
      fontWeight: FontWeight.bold
    ),
    iconTheme: IconThemeData(
      color: accentColor
    )
  ),
  iconTheme: const IconThemeData(
    color: buttonColor
  ),
  textTheme:  const TextTheme(
    displayLarge: TextStyle(
      color: accentColor,
      fontSize: 24,
      fontWeight: FontWeight.bold
    ),
    displayMedium: TextStyle(
      color: accentColor,
      fontSize: 20,
      fontWeight: FontWeight.bold
    ),
    displaySmall: TextStyle(
      color: accentColor,
      fontSize: 18,
      fontWeight: FontWeight.bold
    ),
    headlineMedium: TextStyle(
      color: accentColor,
      fontSize: 16,
      fontWeight: FontWeight.bold
    ),
    headlineSmall: TextStyle(
      color: accentColor,
      fontSize: 14,
      fontWeight: FontWeight.bold
    ),
    headlineLarge: TextStyle(
      color: accentColor,
      fontSize: 12,
      fontWeight: FontWeight.bold
    ),
    bodyLarge: TextStyle(
      color: accentColor,
      fontSize: 14,
      fontWeight: FontWeight.normal
    ),
    bodyMedium: TextStyle(
      color: accentColor,
      fontSize: 12,
      fontWeight: FontWeight.normal
    ),
    bodySmall: TextStyle(
      color: accentColor,
      fontSize: 10,
      fontWeight: FontWeight.normal
    ),

  ),
  buttonTheme: ButtonThemeData(
    buttonColor: buttonColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    )
  ),
);


}