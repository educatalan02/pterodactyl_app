import 'package:dartactyl/dartactyl.dart';
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/data/panel.dart';

class ServerState {
  ServerPowerState state;

  late ValueNotifier<ServerPowerState> stateNotifier = ValueNotifier(state);

  Server server;

  Panel panel;

  ServerState({required this.state, required this.server, required this.panel});
}
