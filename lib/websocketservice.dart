import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class WebSocketService {
  late IOWebSocketChannel _channel;

  Future<void> connect(String url, String token) async {
    _channel = IOWebSocketChannel.connect(url);

    // Autenticarse con el WebSocket
    _channel.sink.add(jsonEncode({
      'event': 'auth',
      'args': [token],
    }));

    // Escuchar los mensajes del WebSocket
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      print('Received: $data');
    });
  }

  void disconnect() {
    _channel?.sink?.close();
  }
}
