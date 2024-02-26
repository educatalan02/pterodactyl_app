import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:pterodactyl_app/presentation/screens/addserver.dart';
import 'package:pterodactyl_app/presentation/screens/mainmenu.dart';
import 'package:pterodactyl_app/presentation/screens/server/console.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  // Open the database and store the reference.

  WidgetsFlutterBinding.ensureInitialized();

  // delete the database
  //await deleteDatabase(join(await getDatabasesPath(), 'servers.db'));

  final database = openDatabase(
    join(await getDatabasesPath(), 'servers.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE servers(socket TEXT, panel TEXT, apiKey TEXT, serverId TEXT, name TEXT)',
      );
    },
    version: 1,
  );

  // Create a server
  Future<void> insertServer(Server server) async {
    final Database db = await database;

    await db.insert(
      'servers',
      server.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.

        // enable dark mode

        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.green),

        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MainMenu(),
        '/addserver': (context) => AddServer(),
      },
    );
  }
}
