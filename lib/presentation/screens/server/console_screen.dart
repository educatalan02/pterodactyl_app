import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import 'package:pterodactyl_app/entities/model/server.dart';
import 'package:pterodactyl_app/presentation/screens/screens.dart';

// ignore: must_be_immutable
class Console extends StatefulWidget {
  Console({super.key, required this.server});
  String socket = '';

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
        if (messages.length > 100) {
          messages.removeRange(0, 99);
        }
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
    super.dispose();

    _channel.sink.close();
  }

  @override
  void initState() {
    super.initState();
    fetchServerDetails(widget.server);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              _channel.sink.close();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            "Console",
            style: TextStyle(fontWeight: FontWeight.w700),
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.black45,
                hintText: "Type a command here...",
              ),
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}
