import 'dart:ffi';

import 'package:pterodactyl_app/entities/model/filetype.dart';

class Directory {
  String fileName;

  String filePath;

  bool isFile;

  FileType fileType;

  Directory(
      {required this.fileName, required this.filePath, required this.fileType, required this.isFile});
}
