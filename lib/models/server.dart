

class Server {

late int id;

late String socketUrl;

late String urlPanel;

late String apiKey;


Server({required this.socketUrl, required this.urlPanel, required this.apiKey});







Map<String, dynamic> toMap() {
  return {
    'id': id,
    'socket': socketUrl,
    'panel': urlPanel,
    'api': apiKey,
  };




}
}


