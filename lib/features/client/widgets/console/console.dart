import 'package:ansix/ansix.dart';
import 'package:dartactyl/dartactyl.dart';
import 'package:dartactyl/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart' as p;
import 'package:pterodactyl_app/ansi/ansi_wrapper.dart';
import 'package:pterodactyl_app/data/server_state.dart';

class Console extends StatefulWidget {
  const Console({super.key, required this.server});

  final ServerState server;

  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  final logs = ValueNotifier<List<String>>([]);
  @override
  void initState() {
    super.initState();
    getWebsocket().then((value) => {
          value.logs.listen((event) {
            print(event.message);
            logs.value = [...logs.value, event.message];
          })
        });
  }

  Future<ServerWebsocket> getWebsocket() async {
    final client = PteroClient.generate(
      url: widget.server.panel.panelUrl,
      apiKey: widget.server.panel.apiKey,
    );

    //await client.getServerWebsocket(serverId: widget.server.server.identifier);

    final websocket = ServerWebsocket(
        client: client, serverId: widget.server.server.identifier);

    return websocket;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: logs,
      builder: (context, value, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: AnsiTextWidget(
                        ansiText:
                            '\x1B[31mEste es un texto rojo\x1B[0m y este es texto normal.'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
