import 'package:flutter/material.dart';

class FileCheckbox extends StatefulWidget {
  FileCheckbox({super.key, required this.isChecked});

  bool isChecked;

  @override
  State<FileCheckbox> createState() => _FileCheckboxState();
}

class _FileCheckboxState extends State<FileCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.isChecked,
      onChanged: (bool? value) => setState(() => widget.isChecked = value!),
    );
  }
}
