import 'package:flutter/material.dart';

class AnsiColorText extends StatelessWidget {
  final String text;

  AnsiColorText({required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    String buffer = '';
    Color currentColor = Colors.grey[400]!;

    final ansiEscape = RegExp(r'\x1B\[\d+m');
    final matches = ansiEscape.allMatches(text);

    int lastMatchEnd = 0;

    for (final match in matches) {
      final matchedString = match.group(0)!;
      final colorCode = matchedString.substring(2, matchedString.length - 1);

      if (match.start > lastMatchEnd) {
        final spanText =
            text.substring(lastMatchEnd, match.start).replaceAll("[6n", "");
        textSpans.add(
            TextSpan(text: spanText, style: TextStyle(color: currentColor)));
      }

      // Ignore non-color escape codes
      if (colorCode.length == 2 && colorCode[0] == '3') {
        currentColor = _getColorFromCode(colorCode);
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      final spanText = text.substring(lastMatchEnd).replaceAll("[6n", "");
      textSpans
          .add(TextSpan(text: spanText, style: TextStyle(color: currentColor)));
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  Color _getColorFromCode(String code) {
    switch (code) {
      case '31':
        return Colors.red;
      case '32':
        return Colors.green;
      case '33':
        return Colors.yellow;
      case '34':
        return Colors.blue;
      case '35':
        return Colors.purple;
      case '36':
        return Colors.cyan;
      case '37':
        return Colors.grey[400]!;
      default:
        return Colors.white;
    }
  }
}
