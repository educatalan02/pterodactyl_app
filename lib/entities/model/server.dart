import 'dart:ffi';

class Server {
  late int id = 0;
  late String socketUrl = '';

  late String panelUrl;

  late String apiKey;
  late String serverId;

  late String name = '';
  late String optionalTag = '';
  

  Server({
    required this.socketUrl,
    required this.panelUrl,
    required this.apiKey,
    required this.name,
    required this.serverId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'socket': socketUrl,
      'panel': panelUrl,
      'apiKey': apiKey,
      'name': name,
      'serverId': serverId,
      'optionalTag': optionalTag,
    };
  }
}
