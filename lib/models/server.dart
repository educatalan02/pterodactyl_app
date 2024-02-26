class Server {
  late String socketUrl = '';

  late String panelUrl;

  late String apiKey;
  late String serverId;

  late String name = '';

  Server({
    required this.socketUrl,
    required this.panelUrl,
    required this.apiKey,
    required this.name,
    required this.serverId,
  });

  Map<String, dynamic> toMap() {
    return {
      'socket': socketUrl,
      'panel': panelUrl,
      'apiKey': apiKey,
      'name': name,
      'serverId': serverId,
    };
  }
}
