import 'dart:convert';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pterodactyl_app/entities/model/directory.dart';
import 'package:pterodactyl_app/entities/model/filetype.dart';
import 'package:pterodactyl_app/entities/model/server.dart';
import 'package:pterodactyl_app/entities/model/usage_data.dart';
import 'package:http/http.dart' as http;
import 'package:pterodactyl_app/presentation/screens/screens.dart';
import 'package:shimmer/shimmer.dart';

import 'package:path/path.dart' as path;

// ignore: must_be_immutable
class ServerPanel extends StatefulWidget {
  const ServerPanel({super.key, required this.server});

  final Server server;

  @override
  State<ServerPanel> createState() => _ServerPanelState();
}

class _ServerPanelState extends State<ServerPanel> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late bool serverIsSuspended = false;

  late final bool animate;
  String currentDirectory = '/';
  List<String> fileAndDirectoryNames = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.server.name),
          actions: [
            if (serverIsSuspended)
              IconButton(
                  icon: const Icon(Icons.power_settings_new_outlined,
                      color: Colors.red),
                  onPressed: () async {
                    final response = await http.post(
                      Uri.parse(
                          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/power'),
                      headers: <String, String>{
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ${widget.server.apiKey}',
                      },
                      body: jsonEncode(<String, String>{
                        'signal': 'start',
                      }),
                    );

                    if (response.statusCode == 204) {
                      setState(() {
                        // snackbar
                        Get.snackbar('server_starting'.tr, '',
                            backgroundColor: Colors.white,
                            colorText: Colors.black);
                        serverIsSuspended = false;
                      });
                    }
                  }),
            if (!serverIsSuspended)
              IconButton(
                icon: const Icon(Icons.power_settings_new, color: Colors.green),
                onPressed: () async {
                  final response = await http.post(
                    Uri.parse(
                        '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/power'),
                    headers: <String, String>{
                      'Accept': 'application/json',
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer ${widget.server.apiKey}',
                    },
                    body: jsonEncode(<String, String>{
                      'signal': 'stop',
                    }),
                  );

                  if (response.statusCode == 204) {
                    setState(() {
                      serverIsSuspended = true;
                    });

                    // snackbar
                    Get.snackbar('server_stopping'.tr, '',
                        backgroundColor: Colors.white, colorText: Colors.black);
                  }
                },
              ),
          ],
        ),
        body: StreamBuilder<UsageData>(
          stream: fetchServerResourcesStream(),
          builder: (BuildContext context, AsyncSnapshot<UsageData> snapshot) {
            if (snapshot.hasData && !serverIsSuspended) {
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GridView.count(
                      crossAxisCount: 4,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.memory),
                                const Text("CPU",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '${snapshot.data!.cpu.toStringAsFixed(2)}%'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.storage),
                                const Text("RAM",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '${(snapshot.data!.ram / 1073741824).toStringAsFixed(2)} GB'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.sd_storage),
                                const Text("Disk",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '${(snapshot.data!.disk / 1073741824).toStringAsFixed(2)} GB'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.timer),
                                const Text("Uptime",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(getUptime(snapshot.data!.uptime)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const TabBar(tabs: [
                    Tab(
                      icon: Icon(Icons.folder),
                      text: 'Files',
                    ),
                    Tab(
                      icon: Icon(Icons.data_object_sharp),
                      text: 'Databases',
                    ),
                    Tab(
                      icon: Icon(Icons.schedule),
                      text: 'Schedules',
                    ),
                    Tab(
                      icon: Icon(Icons.verified_user_sharp),
                      text: 'Users',
                    ),
                    Tab(
                      icon: Icon(Icons.backup),
                      text: 'Backups',
                    ),
                    Tab(
                      icon: Icon(Icons.settings),
                      text: 'Settings',
                    ),
                  ]),
                  Expanded(
                    flex: 4,
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ValueListenableBuilder<String>(
                                valueListenable:
                                    ValueNotifier<String>(currentDirectory),
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              currentDirectory = path
                                                  .dirname(currentDirectory);
                                              fetchAllFiles(currentDirectory)
                                                  .then((value) {
                                                setState(() {
                                                  fileAndDirectoryNames = value
                                                      .map((e) =>
                                                          path.basename(e))
                                                      .toList();
                                                });
                                              });
                                            },
                                            icon: const Icon(Icons.arrow_back)),
                                        Text(currentDirectory),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: ValueListenableBuilder<List<String>>(
                                valueListenable: ValueNotifier<List<String>>(
                                    fileAndDirectoryNames),
                                builder: (context, value, child) {
                                  return ListView.builder(
                                    itemCount: fileAndDirectoryNames.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                              fileAndDirectoryNames[index]),
                                          onTap: () {
                                            var file =
                                                fileAndDirectoryNames[index];

                                            if (file.contains('.')) {
                                              var fileType = path
                                                  .extension(file)
                                                  .substring(1);
                                              var fileName =
                                                  path.basename(file);

                                              Get.dialog(
                                                AlertDialog(
                                                  title: Text(fileName),
                                                  content: Column(
                                                    children: [
                                                      Expanded(
                                                          child: TextField(
                                                        scrollController:
                                                            _scrollController,
                                                        controller: _controller,
                                                        maxLines: null,
                                                      ))
                                                    ],
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                        onPressed: () {
                                                          downloadFile(
                                                              "$currentDirectory/$file",
                                                              file);
                                                        },
                                                        icon: const Icon(
                                                            Icons.download)),
                                                    IconButton(
                                                        onPressed: () {
                                                          updateFileContent(
                                                              "$currentDirectory/$file",
                                                              _controller.text);
                                                        },
                                                        icon: const Icon(
                                                            Icons.save)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.delete))
                                                  ],
                                                ),
                                              );
                                              print(file);
                                              print(currentDirectory +
                                                  "/" +
                                                  file);
                                              getFileContent(
                                                      "$currentDirectory/$file")
                                                  .then((value) {
                                                _controller.text = value;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollController.jumpTo(
                                                      _scrollController.position
                                                          .maxScrollExtent);
                                                });
                                              });
                                            } else {
                                              // open directory
                                              currentDirectory = path.join(
                                                  currentDirectory, file);
                                              fetchAllFiles(currentDirectory)
                                                  .then((value) {
                                                setState(() {
                                                  print(file);
                                                  fileAndDirectoryNames = value
                                                      .map((e) =>
                                                          path.basename(e))
                                                      .toList();
                                                });
                                              });
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        

                        const Text('Databases'),
                        const Text('Schedules'),
                        const Text('Users'),
                        const Text('Backups'),
                        const Text('Settings'),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: GridView.count(
                  crossAxisCount: 4,
                  children: [
                    Card(
                      color: Colors.grey[850],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey[850],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey[850],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey[850],
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.laptop_chromebook),
              label: 'console'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'settings'.tr,
            ),
          ],
          onTap: (value) {
            if (value == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Console(server: widget.server)));
            } else if (value == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ServerSettings(server: widget.server)));
            }
          },
        ),
      ),
    );
  }

  Future<List<String>> fetchAllFiles(String directory) async {
    final response = await http.get(
      Uri.parse(
          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/files/list?directory=$directory'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.server.apiKey}',
      },
    );

    var data = jsonDecode(response.body);

    var allFiles = List<String>.empty(growable: true);

    if (data['data'] != null) {
      for (var file in data["data"]) {
        String name = directory == '/'
            ? '${file["attributes"]["name"]}'
            : '$directory/${file["attributes"]["name"]}';
        allFiles.add(name);

        print(name);
      }
    }

    return allFiles;
  }

  String getUptime(int uptime) {
    Duration uptimeDuration = Duration(milliseconds: uptime);
    if (uptimeDuration.inDays == 0) {
      return '${uptimeDuration.inHours.remainder(24)}h ${uptimeDuration.inMinutes.remainder(60)}m';
    }
    if (uptimeDuration.inHours == 0) {
      return '${uptimeDuration.inMinutes.remainder(60)}m';
    }

    return '${uptimeDuration.inDays}d ${uptimeDuration.inHours.remainder(24)}h ${uptimeDuration.inMinutes.remainder(60)}m ';
  }

  @override
  void initState() {
    super.initState();

    fetchServerResources();

    fetchAllFiles('/').then((value) {
      setState(() {
        fileAndDirectoryNames = value.map((e) => path.basename(e)).toList();
      });
    });
  }

  Future<List<String>> fetchFiles(String directory) async {
    final response = await http.get(
      Uri.parse(
          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/files/list?directory=$directory'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.server.apiKey}',
      },
    );

    var data = jsonDecode(response.body);
    var directories = List<String>.empty(growable: true);
    var files = List<String>.empty(growable: true);

    if (data['data'] != null) {
      for (var file in data["data"]) {
        String name = directory == '/'
            ? '${file["attributes"]["name"]}'
            : '$directory/${file["attributes"]["name"]}';
        fileAndDirectoryNames.add(name);
      }
    }

    return files;
  }

  Future<UsageData> fetchServerResources() async {
    double cpuUsage = 0.0;
    int memoryUsage = 0;
    int diskUsage = 0;
    int uptime = 0;
    String currentState = '';
    bool isSuspended = false;

    final response = await http.get(
      Uri.parse(
          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/resources'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.server.apiKey}',
      },
    );

    switch (response.statusCode) {
      case 200:
        // Si el servidor devuelve una respuesta OK, parsea el JSON.
        //print(jsonDecode(response.body));
        final data = jsonDecode(response.body);
        // {"object":"stats","attributes":{"current_state":"running","is_suspended":false,"resources":{"memory_bytes":1023197184,"cpu_absolute":62.413,"disk_bytes":3249573374,"network_rx_bytes":17457522,"network_tx_bytes":206805255,"uptime":68212135}}}

        cpuUsage = data["attributes"]["resources"]["cpu_absolute"];

        memoryUsage = data["attributes"]["resources"]["memory_bytes"];

        diskUsage = data["attributes"]["resources"]["disk_bytes"];

        uptime = data["attributes"]["resources"]["uptime"];

        currentState = data["attributes"]["current_state"];

        isSuspended = data["attributes"]["is_suspended"];

        return UsageData(
          uptime: uptime,
          cpu: cpuUsage,
          ram: memoryUsage,
          disk: diskUsage,
          isSuspended: isSuspended,
          currentState: currentState,
        );

      case 401:
        throw Exception('Unauthorized request. Check your API key.');
      case 404:
        throw Exception('Server not found. Check your server ID.');
      default:
        throw Exception(
            'Failed to load server details. Status code: ${response.statusCode}');
    }
  }

  Future<String> getFileContent(String file) async {
    var response = await http.get(
      Uri.parse(
          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/files/contents?file=$file'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.server.apiKey}',
      },
    );

    return response.body;
  }

  Stream<UsageData> fetchServerResourcesStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await fetchServerResources();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void downloadFile(String dir, String file) async {
    var response = await http.get(
      Uri.parse(
          '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/files/download?file=$dir'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.server.apiKey}',
      },
    );

    Dio dio = Dio();

    var savePath = await getApplicationDocumentsDirectory();

    var data = jsonDecode(response.body);

    await dio
        .download(data['attributes']['url'], '${savePath.path}/$file',
            options: Options(headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.server.apiKey}'
            }))
        .then((_) {
      print('Download complete');
    }).catchError((error) {
      print('Download failed');
      print(error);
    });

    print(response.body);
  }

  void updateFileContent(String file, String content) async {
    var response = await http.post(
        Uri.parse(
            '${widget.server.panelUrl}/api/client/servers/${widget.server.serverId}/files/write?file=$file'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.server.apiKey}',
        },
        body: jsonEncode(content));

    print(response.body);
  }
}
