import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class Console extends StatefulWidget {
  Console({super.key});
  String socket = '';
  List<String> messages = [];

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  late IOWebSocketChannel _channel;
  List<String> messages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void connect(String url, String token) {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));

    // Autenticarse con el WebSocket
    _channel.sink.add(jsonEncode({
      'event': 'auth',
      'args': [token],
    }));

    // Escuchar los mensajes del WebSocket
    _channel.stream.listen((event) {
      Map data = jsonDecode(event);
      if (data["event"] == "console output") {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
        setState(() {
          messages.add(data["args"][0].toString());
        });

        //if (messages.length > 100) messages.removeRange(0, 99);

        // Scroll to the end of the list after a new message is added
      }
    });
  }

  String removeAnsiCodes(String input) {
    final ansiEscape = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
    return input.replaceAll(ansiEscape, '');
  }

  void sendCommand() {
    _channel.sink.add(jsonEncode({
      'event': 'send command',
      'args': [_controller.text],
    }));
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
    _controller.clear();
  }

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

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    fetchServerDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            _channel.sink.close();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Console",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alinea el texto a la izquierda
                    children: [
                      for (var message in messages)
                        Text(
                          removeAnsiCodes(message),
                          style: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            TextField(
              autofocus: true,
              onSubmitted: (text) {
                sendCommand();
                _scrollController.jumpTo(
                  _scrollController.position.maxScrollExtent,
                );
                _controller.clear();
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.black26,
                hintStyle: TextStyle(color: Colors.white),
                prefixStyle: TextStyle(color: Colors.white),
                hintText: "Type a command here...",
                prefixText: 'container:~/\$ ',
              ),
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}
