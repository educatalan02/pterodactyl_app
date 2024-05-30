import 'dart:async';
import 'package:dartactyl/dartactyl.dart';
import 'package:dartactyl/websocket.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pterodactyl_app/ansi/ansi_wrapper.dart';

import 'package:pterodactyl_app/data/server_state.dart';
import 'package:flutter/src/widgets/async.dart' as async;

class ConsoleController extends GetxController {
  var messages = <String>[].obs;

  var powerState = ServerPowerState.offline.obs;

  ServerWebsocket? webSocket;

  String removeAnsiCodes(String input) {
    final ansiEscape = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
    return input.replaceAll(ansiEscape, '');
  }

  void addMessage(String message) {
    if (messages.length > 100) {
      messages.removeRange(0, 99);
    }
    messages.add((message));
  }

  void clearMessages() {
    messages.clear();
  }

  void removeMessage(int index) {
    messages.removeAt(index);
  }
}

class Console extends StatefulWidget {
  const Console({super.key, required this.server});

  final ServerState server;

  @override
  ConsoleState createState() => ConsoleState();
}

class ConsoleState extends State<Console> {
  bool listenerAdded = false;
  final scrollController = ScrollController();
  late ConsoleController controller;
  final TextEditingController textController = TextEditingController();
  String removeAnsiCodes(String input) {
    final ansiEscape = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
    return input.replaceAll(ansiEscape, '');
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConsoleController());

    getWebsocket().then((value) {
      controller.webSocket = value;

      if (!listenerAdded) {
        controller.webSocket?.logs.listen((event) {
          Logger().d(event.message.toString());
          controller.messages.add((event.message.toString()));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });
        });

        controller.webSocket?.powerState.listen((event) {
          controller.powerState.value = event;
        });

        listenerAdded = true;
      }
    });
  }

  Future<ServerWebsocket> getWebsocket() async {
    if (controller.webSocket == null) {
      final client = PteroClient.generate(
        url: widget.server.panel.panelUrl,
        apiKey: widget.server.panel.apiKey,
      );

      final websocket = ServerWebsocket(
          client: client, serverId: widget.server.server.identifier);
      return websocket;
    }
    return controller.webSocket!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServerWebsocket>(
      future: getWebsocket(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == async.ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          controller.webSocket = snapshot.data;
          return Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FilledButton.tonalIcon(
                          onPressed: () {
                            getWebsocket().then((value) => {
                                  value
                                      .setPowerState(ServerPowerAction.restart),
                                });
                          },
                          icon: const Icon(Icons.restart_alt),
                          label: Text(
                            'restart'.tr,
                          )),
                      const SizedBox(width: 10),
                      if (controller.powerState.value ==
                          ServerPowerState.running)
                        TextButton.icon(
                            onPressed: () {
                              getWebsocket().then((value) => {
                                    value.setPowerState(ServerPowerAction.stop),
                                  });
                            },
                            icon: const Icon(Icons.stop),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            label: Text(
                              'stop'.tr,
                            ))
                      else
                        TextButton.icon(
                            onPressed: () {
                              getWebsocket().then((value) => {
                                    value
                                        .setPowerState(ServerPowerAction.start),
                                  });
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 69, 184, 73)),
                            ),
                            label: Text(
                              'start'.tr,
                            )),
                      const SizedBox(width: 10),
                      FilledButton.tonalIcon(
                          onPressed: () {
                            controller.clearMessages();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.delete),
                          label: Text('clear'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.messages.length,
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 4.0),
                                    child: AnsiColorText(
                                      text: controller.messages[index],
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'type_a_command'.tr,
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          controller.webSocket
                              ?.sendCommand(textController.text);
                          textController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
