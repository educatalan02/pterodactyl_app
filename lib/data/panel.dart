class Panel {
  late int id = 0;

  late String panelUrl;

  late String apiKey;

  late String name = '';

  Panel({
    required this.panelUrl,
    required this.apiKey,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'panel': panelUrl,
      'apiKey': apiKey,
      'name': name,
    };
  }
}
