import 'package:flutter/material.dart';

class FileCheckbox extends StatefulWidget {
  final bool isChecked;

  const FileCheckbox({super.key, required this.isChecked});

  @override
  FileCheckboxState createState() => FileCheckboxState();
}

class FileCheckboxState extends State<FileCheckbox> {
  bool? isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value;
          });
        });
  }
}
