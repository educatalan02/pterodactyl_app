import 'package:code_editor/code_editor.dart';
import 'package:dartactyl/dartactyl.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileEditorWidget extends StatefulWidget {
  final String fileName;
  final PteroClient client;
  final Server server;
  const FileEditorWidget(
      {super.key,
      required this.fileName,
      required this.client,
      required this.server});

  @override
  State<FileEditorWidget> createState() => _FileEditorState();
}

class _FileEditorState extends State<FileEditorWidget> {
  late EditorModel model;

  @override
  void initState() {
    super.initState();

    widget.client
        .getFileContents(file: widget.fileName, serverId: widget.server.uuid)
        .then((value) => {
              setState(() {
                model = EditorModel(
                  files: [
                    FileEditor(
                        readonly: false,
                        code: value,
                        name: path.basename(widget.fileName),
                        language: path.extension(widget.fileName)),
                  ],
                  styleOptions: EditorModelStyleOptions(
                    showUndoRedoButtons: true,
                    reverseEditAndUndoRedoButtons: true,
                  )..defineEditButtonPosition(
                      bottom: 10,
                      left: 15,
                    ),
                );
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.fileName}'),
      ),
      body: CodeEditor(
        formatters: const ['xml', 'dat', 'log', 'css', 'html', 'json', 'yaml'],
        model: model,
      ),
    );
  }
}
