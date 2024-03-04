import 'package:flutter/material.dart';

class AppTheme {
  static const colorList = [
    Color.fromRGBO(32, 30, 31, 1),
    Color.fromRGBO(46,94, 170, 1),
    Color.fromRGBO(42, 43, 42, 1),
    Color.fromRGBO(254, 239, 221, 1),
    Colors.red,
    Colors.purple,
    Colors.deepOrange,
    Colors.orange,
    Colors.pink,
    Colors.pinkAccent
  ];

  final int colorSeleccionado;
  final bool isDarkMode;

  AppTheme({required this.colorSeleccionado, this.isDarkMode = false})
      : assert(
            colorSeleccionado >= 0, 'El color ha de ser un valor superior a 0'),
        assert(colorSeleccionado <= colorList.length,
            'El color ha de estar comprendido en la lista');

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        
        
        appBarTheme: AppBarTheme(
       
          backgroundColor: isDarkMode ? colorList[1] : colorList[0],
          titleTextStyle: TextStyle(
            color: isDarkMode ? colorList[3] : colorList[1],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue[700],
        primaryColorLight: Colors.blue[100],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          backgroundColor: isDarkMode ? colorList[2] : colorList[3],
          errorColor: Colors.red,
          
          

        ),
        canvasColor: Colors.grey[50],
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey[300],
        ),
        cardColor: Colors.white,
        dividerColor: Colors.grey,
        highlightColor: Colors.amber[700],
        splashColor: Colors.amber[200],
        unselectedWidgetColor: Colors.grey[400],
        disabledColor: Colors.grey[200],
        buttonTheme: ButtonThemeData(
          buttonColor: isDarkMode ? colorList[0] : colorList[1],
          textTheme: ButtonTextTheme.primary,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: isDarkMode ? Colors.grey : Colors.blue,
            accentColor: isDarkMode ? Colors.grey : Colors.blue,
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ),
        ),
        secondaryHeaderColor: Colors.blue[50],
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue[700],
          selectionColor: Colors.blue[200],
          selectionHandleColor: Colors.blue[400],
        ),

        textTheme:  TextTheme(
          displayLarge: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          displayMedium: TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          displaySmall: TextStyle(
            fontSize: 24.0,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          titleLarge: TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
            color:  isDarkMode ? Colors.white : Colors.black,
            
          ),
          titleMedium: TextStyle(
            fontSize: 16.0,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          titleSmall: TextStyle(
            fontSize: 10.0,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: 12.0,
            color:  isDarkMode ? Colors.white : Colors.black,
          ),

          

        ),

        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.blue[600],
          labelStyle: TextStyle(
            color: Colors.blue[600],
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[600]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[600]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[600]!,
            ),
          ),

          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),


          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),

          errorStyle: const TextStyle(
            color: Colors.red,
          ),

          hintStyle: const TextStyle(
            color: Colors.grey,
          ),

          helperStyle: const TextStyle(
            color: Colors.grey,
          ),

          errorMaxLines: 3,
          
        )
        
      
        
      );
}