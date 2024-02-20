import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IOWebSocketChannel _channel;
  final TextEditingController _controller = TextEditingController();
  final List<String> messages = [];

  void fetchServerDetails() async {
    const String apiKey = 'ptlc_weVB5KEdhOIFyqj5Gq01olJLlhOSRqQHq78x570bPFN';
    const String serverId = '1a013dcb';

    final response = await http.get(
      Uri.parse(
          'https://panel.redstoneplugins.com/api/client/servers/$serverId/websocket'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    switch (response.statusCode) {
      case 200:
        // Si el servidor devuelve una respuesta OK, parsea el JSON.
        print(jsonDecode(response.body));
        final data = jsonDecode(response.body);

        connect(data["data"]["socket"], data["data"]["token"]);

        break;
      case 401:
        throw Exception('Unauthorized request. Check your API key.');
      case 404:
        throw Exception('Server not found. Check your server ID.');
      default:
        throw Exception(
            'Failed to load server details. Status code: ${response.statusCode}');
    }
  }

  void connect(String url, String token) {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));

    // Autenticarse con el WebSocket
    _channel.sink.add(jsonEncode({
      'event': 'auth',
      'args': [token],
    }));

    // Escuchar los mensajes del WebSocket
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data["event"] == "console output") {
        setState(() {
          messages.add(data["args"].toString());
        });
      }
    });
  }

  void sendCommand() {
    _channel.sink.add(jsonEncode({
      'event': 'command',
      'args': [_controller.text],
    }));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    fetchServerDetails();
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Client'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          TextField(
            controller: _controller,
            onSubmitted: (value) {
              sendCommand();
            },
            decoration: InputDecoration(
              labelText: 'Enter command',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendCommand,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
