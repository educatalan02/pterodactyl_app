import 'package:dartactyl/dartactyl.dart';
import 'package:flutter/material.dart';
import 'package:pterodactyl_app/data/server_state.dart';
import 'package:path/path.dart' as path;
import 'package:pterodactyl_app/features/client/widgets/file_explorer/file_checkbox.dart';

class ServerFileExplorer extends StatefulWidget {
  ServerFileExplorer({super.key, required this.server});

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

    return filesLookup.files;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
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
                          icon: const Icon(Icons.arrow_back)),
                      Text(currentDirectory),
                    ],
                  ),
                );
              },
            ),
            Expanded(
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
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  if (files[index].isFile) {
                                    // Si es un archivo, abre el archivo
                                  } else {
                                    // Si es un directorio, cambia el directorio actual
                                    setState(() {
                                      currentDirectory = path.join(
                                          currentDirectory, files[index].name);
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
                                        // Código para la opción 2
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
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    loadFiles();
  }
}
