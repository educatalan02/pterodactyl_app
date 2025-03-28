import 'package:dartactyl/dartactyl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:path/path.dart' as path;
import 'package:pterodactyl_app/features/client/server/widgets/file_explorer/file_checkbox.dart';
import 'package:pterodactyl_app/features/client/server/widgets/file_explorer/file_editor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServerFileExplorer extends StatefulWidget {
  const ServerFileExplorer({super.key, required this.server});

  final ServerState server;

  @override
  State<ServerFileExplorer> createState() => _ServerFileExplorerState();
}

class _ServerFileExplorerState extends State<ServerFileExplorer> {
  List<FileObject> files = [];
  List<bool> checked = [];
  String currentDirectory = "/";

  PteroClient getClient() {
    return PteroClient.generate(
        url: widget.server.panel.panelUrl, apiKey: widget.server.panel.apiKey);
  }

  Future<FractalListData<FileObject>> findFiles(String directory) {
    return getClient()
        .listFiles(serverId: widget.server.server.uuid, directory: directory);
  }

  Future<List<FileObject>> loadFiles() async {
    final filesLookup = await findFiles(currentDirectory);
    files = filesLookup.files;
    checked = List<bool>.filled(
        files.length, false); // Actualiza la lista 'checked' aquí
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<String>(
          valueListenable: ValueNotifier<String>(currentDirectory),
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentDirectory = path.dirname(currentDirectory);

                          loadFiles();
                        });
                      },
                      icon: const Icon(Icons.arrow_upward)),
                  Flexible(
                    child: Text(
                      currentDirectory,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: ValueNotifier<String>(currentDirectory),
                builder: (context, value, child) {
                  return FutureBuilder<List<FileObject>>(
                    future:
                        loadFiles(), // Asegúrate de que loadFiles() devuelve un Future
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FileObject>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Muestra un indicador de carga mientras se cargan los archivos
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Los archivos se han cargado correctamente
                        List<FileObject>? files = snapshot.data;
                        if (checked.isEmpty) {
                          checked = List<bool>.filled(files!.length, false);
                        }
                        return ListView.builder(
                          itemCount: files!.length,
                          itemBuilder: (context, index) {
                            if (index < files.length) {
                              return Card(
                                elevation: 0,
                                child: ListTile(
                                  onTap: () {
                                    if (files[index].isFile) {
                                      Get.to(() => FileEditorWidget(
                                            fileName: path.join(
                                                currentDirectory,
                                                files[index].name),
                                            client: getClient(),
                                            server: widget.server.server,
                                          ));
                                    } else {
                                      // Si es un directorio, cambia el directorio actual
                                      setState(() {
                                        currentDirectory = path.join(
                                            currentDirectory,
                                            files[index].name);
                                        loadFiles();
                                      });
                                    }
                                  },
                                  trailing: PopupMenuButton<int>(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          value: 1, child: Icon(Icons.delete)),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Icon(Icons.download),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      // Aquí puedes manejar la opción seleccionada
                                      switch (value) {
                                        case 1:
                                          getClient().deleteFiles(
                                            FileBodyListString(
                                                rootDir: currentDirectory,
                                                files: [files[index].name]),
                                            serverId: widget.server.server.uuid,
                                            onSendProgress: (count, total) {
                                              if (count == total) {
                                                loadFiles();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Deleted ${files[index].name}")));
                                              }
                                            },
                                          );

                                          break;
                                        case 2:
                                          // Descarga el archivo
                                          getClient()
                                              .getFileDownloadUrl(
                                                  serverId:
                                                      widget.server.server.uuid,
                                                  file: files[index].name)
                                              .then((value) async {
                                            final url = value.attributes.url;

                                            var dio = Dio();
                                            try {
                                              var dir =
                                                  await getApplicationDocumentsDirectory();
                                              await dio.download(url.toString(),
                                                  '${dir?.path}/${files[index].name}');
                                            } catch (e) {
                                              Logger().e(
                                                  'Error downloading file: $e');
                                            }
                                          });

                                          break;
                                      }
                                    },
                                  ),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FileCheckbox(isChecked: checked[index]),
                                      Icon(files[index].isFile
                                          ? Icons.file_copy
                                          : Icons.folder),
                                    ],
                                  ),
                                  title: Text(files[index].name),
                                ),
                              );
                            }
                            return null;
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    loadFiles();
  }
}
