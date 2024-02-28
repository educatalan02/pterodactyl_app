import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pterodactyl_app/models/server.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Console extends StatefulWidget {
  Console({super.key, required this.server});
  String socket = '';
  List<String> messages = [];

  late Server server;

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
        setState(() {
          messages.add(data["args"][0].toString());
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        });
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

    _controller.clear();
  }

  void fetchServerDetails(Server server) async {
    //const String apiKey = 'ptlc_weVB5KEdhOIFyqj5Gq01olJLlhOSRqQHq78x570bPFN';
    //const String serverId = '1a013dcb';

    final response = await http.get(
      Uri.parse(
          '${server.panelUrl}/api/client/servers/${server.serverId}/websocket'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${server.apiKey}',
      },
    );

    switch (response.statusCode) {
      case 200:
        // Si el servidor devuelve una respuesta OK, parsea el JSON.
        //print(jsonDecode(response.body));
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
    fetchServerDetails(widget.server);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              _channel.sink.close();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "Console",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          )),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alinea el texto a la izquierda
                  children: [
                    for (var message in messages)
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          removeAnsiCodes(message),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.black45,
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
