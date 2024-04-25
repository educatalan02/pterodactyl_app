import 'package:dartactyl/dartactyl.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:pterodactyl_app/features/client/controller/servercontroller.dart';
import 'package:pterodactyl_app/features/client/widgets/server_fileexplorer.dart';

class ServerPowerButton extends StatefulWidget {
  final ServerState server;
  final PteroClient client;
  final ServerController controller;

  const ServerPowerButton(
      {super.key,
      required this.server,
      required this.client,
      required this.controller});

  @override
  _ServerPowerButtonState createState() => _ServerPowerButtonState();
}

class _ServerPowerButtonState extends State<ServerPowerButton> {
  late ServerPowerState _state;

  Color getIconColor() {
    switch (_state) {
      case ServerPowerState.running:
        return Colors.green;
      case ServerPowerState.offline:
        return Colors.red;
      case ServerPowerState.starting:
        return Colors.yellow;
      case ServerPowerState.stopping:
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  IconData getIconData() {
    switch (_state) {
      case ServerPowerState.running:
        return LineAwesomeIcons.power_off;
      case ServerPowerState.offline:
        return LineAwesomeIcons.power_off;
      case ServerPowerState.starting:
        return LineAwesomeIcons.power_off;
      case ServerPowerState.stopping:
        return LineAwesomeIcons.power_off;
      default:
        return LineAwesomeIcons.power_off;
    }
  }

  @override
  void initState() {
    super.initState();
    _state = widget.server.state;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0, // Cambia esto al ancho que desees
      height: 40.0, // Cambia esto al alto que desees
      decoration: BoxDecoration(
        color: _state == ServerPowerState.running
            ? Colors.green[100]
            : Colors.red[100],
        border: Border.all(
          width: 2,
          color: _state == ServerPowerState.running
              ? Colors.green[400]!
              : Colors.red[400]!,
        ),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 24,
                onPressed: null,
                icon: Icon(
                  getIconData(),
                  color: getIconColor(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
