import 'package:dartactyl/dartactyl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:highlight/languages/xml.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/css.dart';
import 'package:highlight/languages/shell.dart';
import 'package:highlight/languages/yaml.dart';

import 'package:flutter_highlight/themes/darcula.dart' show darculaTheme;
import 'package:highlight/src/mode.dart' show Mode;

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
  late CodeController controller;

  Mode getFileMode(String fileName) {
    var extension = path.extension(fileName);

    switch (extension) {
      case '.xml':
        return xml;
      case '.json':
        return json;
      case '.dart':
        return dart;
      case '.js':
        return javascript;
      case '.css':
        return css;
      case '.sh':
        return shell;
      case '.yaml':
      case '.yml':
        return yaml;
      default:
        return xml;
    }
  }

  @override
  void initState() {
    super.initState();

    controller = CodeController(
        text: 'Loading...', language: getFileMode(widget.fileName));

    widget.client
        .getFileContents(file: widget.fileName, serverId: widget.server.uuid)
        .then((value) => {
              setState(() {
                controller = CodeController(
                    text: value, language: getFileMode(widget.fileName));
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.fileName}'),
      ),
      body: Expanded(
        child: CodeTheme(
          data: CodeThemeData(styles: darculaTheme),
          child: SingleChildScrollView(
            child: CodeField(
              controller: controller,
              onChanged: (p0) {
                Logger().d(p0);
                widget.client.writeFile(p0,
                    serverId: widget.server.uuid, file: widget.fileName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
