
import 'package:dartactyl/dartactyl.dart';
import 'package:pterodactyl_app/data/panel.dart';

class ServerState{

  ServerPowerState state;

  Server server;

  Panel panel;

  ServerState({required this.state, required this.server, required this.panel});


}