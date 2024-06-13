import 'dart:async';
import 'package:dartactyl/dartactyl.dart';
import 'package:dartactyl/websocket.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pterodactyl_app/ansi/ansi_wrapper.dart';

import 'package:pterodactyl_app/data/server_state.dart';
import 'package:flutter/src/widgets/async.dart' as async;
import 'package:socket_io_client/socket_io_client.dart';

class ConsoleController extends GetxController {
  var messages = <String>[].obs;

  var powerState = ServerPowerState.offline.obs;

  var cpu_usage = 0.0.obs;
  var memory_usage = 0.0.obs;
  var memory_limit = 0.0.obs;

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
        controller.webSocket?.stats.listen((event) {
          controller.powerState.value = event.state;
          Logger().d("Stats: ${event.network}");
          controller.cpu_usage.value = event.cpuAbsolute;
          controller.memory_usage.value =
              event.memoryBytes / 1024 / 1024 / 1024;
          controller.memory_limit.value =
              event.memoryLimitBytes / 1024 / 1024 / 1024;
        });
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
                // ...
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth < 600) {
                        // Ajusta este valor según tus necesidades
                        // En dispositivos móviles, muestra solo los iconos
                        return Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.restart_alt),
                              onPressed: () {
                                getWebsocket().then((value) => {
                                      value.setPowerState(
                                          ServerPowerAction.restart),
                                    });
                              },
                            ),
                            Obx(() {
                              if (controller.powerState.value ==
                                  ServerPowerState.running) {
                                return IconButton(
                                  icon: const Icon(Icons.stop),
                                  onPressed: () {
                                    getWebsocket().then((value) => {
                                          value.setPowerState(
                                              ServerPowerAction.stop),
                                        });
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    getWebsocket().then((value) => {
                                          value.setPowerState(
                                              ServerPowerAction.start),
                                        });
                                  },
                                );
                              }
                            }),
                            const Spacer(),
                            Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                      "${"cpu".tr}: ${controller.cpu_usage.value.toStringAsFixed(2)}%")),
                            ),
                            const SizedBox(width: 8),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    "${"memory".tr}: ${controller.memory_usage.value.toStringAsFixed(2)}/${controller.memory_limit.value.toStringAsFixed(2)}GB"),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // En dispositivos más grandes, muestra los iconos y el texto
                        return Row(
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: () {
                                getWebsocket().then((value) => {
                                      value.setPowerState(
                                          ServerPowerAction.restart),
                                    });
                              },
                              icon: const Icon(Icons.restart_alt),
                              label: Text('restart'.tr),
                            ),
                            SizedBox(width: 8),
                            Obx(() {
                              if (controller.powerState.value ==
                                  ServerPowerState.running) {
                                return FilledButton.tonalIcon(
                                  onPressed: () {
                                    getWebsocket().then((value) => {
                                          value.setPowerState(
                                              ServerPowerAction.stop),
                                        });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.red[800]),
                                  ),
                                  icon: const Icon(Icons.stop),
                                  label: Text('stop'.tr),
                                );
                              } else if (controller.powerState.value ==
                                  ServerPowerState.offline) {
                                return FilledButton.tonalIcon(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green[800]),
                                  ),
                                  onPressed: () {
                                    getWebsocket().then((value) => {
                                          value.setPowerState(
                                              ServerPowerAction.start),
                                        });
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: Text('start'.tr),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                            // ...

                            const Spacer(),
                            Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                      "${"cpu".tr}: ${controller.cpu_usage.value.toStringAsFixed(2)}%")),
                            ),
                            const SizedBox(width: 8),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    "${"memory".tr}: ${controller.memory_usage.value.toStringAsFixed(2)}/${controller.memory_limit.value.toStringAsFixed(2)}GB"),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
// ...,

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
