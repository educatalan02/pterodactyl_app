import 'package:flutter/material.dart';

class FileCheckbox extends StatefulWidget {
  final bool isChecked;

  FileCheckbox({required this.isChecked});

  @override
  _FileCheckboxState createState() => _FileCheckboxState();
}

class _FileCheckboxState extends State<FileCheckbox> {
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
