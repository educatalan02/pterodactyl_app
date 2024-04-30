import 'package:flutter/material.dart';

class AnsiWrapper {
  static TextStyle parseAnsiCode(String ansiCode) {
    // Mapea los códigos de escape ANSI a los estilos correspondientes

    final codes = ansiCode.split(';');
    TextStyle textStyle = TextStyle();

    for (String code in codes) {
      switch (code) {
        // Estilos de fuente
        case '0':
          textStyle = textStyle.copyWith(
              fontWeight: FontWeight.normal, fontStyle: FontStyle.normal);
          break;
        case '1':
          textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
          break;
        case '2':
          textStyle = textStyle.copyWith(fontWeight: FontWeight.normal);
          break;
        case '3':
          textStyle = textStyle.copyWith(fontStyle: FontStyle.italic);
          break;
        case '4':
          textStyle = textStyle.copyWith(decoration: TextDecoration.underline);
          break;
        case '5':
          textStyle =
              textStyle.copyWith(decoration: TextDecoration.lineThrough);
          break;

        // Colores de texto
        case '30':
          textStyle = textStyle.copyWith(color: Colors.black);
          break;
        case '31':
          textStyle = textStyle.copyWith(color: Colors.red);
          break;
        case '32':
          textStyle = textStyle.copyWith(color: Colors.green);
          break;
        case '33':
          textStyle = textStyle.copyWith(color: Colors.yellow);
          break;
        case '34':
          textStyle = textStyle.copyWith(color: Colors.blue);
          break;
        case '35':
          textStyle = textStyle.copyWith(color: Colors.purple);
          break;
        case '36':
          textStyle = textStyle.copyWith(color: Colors.cyan);
          break;
        case '37':
          textStyle = textStyle.copyWith(color: Colors.white);
          break;
        case '90':
          textStyle = textStyle.copyWith(color: Colors.grey);
          break;
        case '91':
          textStyle = textStyle.copyWith(color: Colors.redAccent);
          break;
        case '92':
          textStyle = textStyle.copyWith(color: Colors.greenAccent);
          break;
        case '93':
          textStyle = textStyle.copyWith(color: Colors.yellowAccent);
          break;
        case '94':
          textStyle = textStyle.copyWith(color: Colors.blueAccent);
          break;
        case '95':
          textStyle = textStyle.copyWith(color: Colors.purpleAccent);
          break;
        case '96':
          textStyle = textStyle.copyWith(color: Colors.cyanAccent);
          break;
        case '97':
          textStyle = textStyle.copyWith(color: Colors.white70);
          break;

        // Colores de fondo
        case '40':
          textStyle = textStyle.copyWith(backgroundColor: Colors.black);
          break;
        case '41':
          textStyle = textStyle.copyWith(backgroundColor: Colors.red);
          break;
        case '42':
          textStyle = textStyle.copyWith(backgroundColor: Colors.green);
          break;
        case '43':
          textStyle = textStyle.copyWith(backgroundColor: Colors.yellow);
          break;
        case '44':
          textStyle = textStyle.copyWith(backgroundColor: Colors.blue);
          break;
        case '45':
          textStyle = textStyle.copyWith(backgroundColor: Colors.deepPurple);
          break;
        case '46':
          textStyle = textStyle.copyWith(backgroundColor: Colors.cyan);
          break;
        case '47':
          textStyle = textStyle.copyWith(backgroundColor: Colors.white);
          break;
        case '100':
          textStyle = textStyle.copyWith(backgroundColor: Colors.grey);
          break;
        case '101':
          textStyle = textStyle.copyWith(backgroundColor: Colors.redAccent);
          break;
        case '102':
          textStyle = textStyle.copyWith(backgroundColor: Colors.greenAccent);
          break;
        case '103':
          textStyle = textStyle.copyWith(backgroundColor: Colors.yellowAccent);
          break;
        case '104':
          textStyle = textStyle.copyWith(backgroundColor: Colors.blueAccent);
          break;
        case '105':
          textStyle = textStyle.copyWith(backgroundColor: Colors.purpleAccent);
          break;
        case '106':
          textStyle = textStyle.copyWith(backgroundColor: Colors.cyanAccent);
          break;
        case '107':
          textStyle = textStyle.copyWith(backgroundColor: Colors.white70);
          break;

        default:
          break;
      }
    }
    return textStyle;
  }

  static List<TextSpan> parseAnsiCodes(String input) {
    final pattern = RegExp(r'\[(\d+(;\d+)*)m');
    final matches = pattern.allMatches(input);

    List<TextSpan> textSpans = [];
    int currentPosition = 0;

    for (Match match in matches) {
      final ansiCode = match.group(1);
      final startIndex = match.start;
      final endIndex = match.end;

      final textBefore = input.substring(currentPosition, startIndex);
      final textAfter = input.substring(endIndex);

      if (textBefore.isNotEmpty) {
        textSpans.add(TextSpan(text: textBefore));
      }

      final textStyle = parseAnsiCode(ansiCode!);
      textSpans.add(TextSpan(
          text: input.substring(startIndex, endIndex), style: textStyle));

      currentPosition = endIndex;

      if (textAfter.isEmpty) {
        textSpans.add(TextSpan(text: textAfter));
      }
    }

    return textSpans;
  }

  static RichText extractAnsiTextWidget(String input) {
    final textSpans = parseAnsiCodes(input);

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class AnsiEscapeText extends StatelessWidget {
  final String text;

  AnsiEscapeText({required this.text});

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];

    RegExp regex = RegExp(r'\u001b\[\d+m');

    List<String> segments = text.split(
        regex); // Dividir el texto en segmentos utilizando los códigos de escape
    Iterable<Match> matches = regex
        .allMatches(text); // Buscar todos los códigos de escape en el texto

    int matchIndex = 0; // Índice para recorrer los códigos de escape

    for (var segment in segments) {
      if (segment.isNotEmpty) {
        spans.add(TextSpan(text: segment));
      }

      if (matchIndex < matches.length) {
        Match match = matches.elementAt(matchIndex);
        String escapeCode = match.group(0)!;

        TextStyle style = _getStyleFromEscapeCode(escapeCode);
        spans.add(TextSpan(
            text: ' ',
            style: style)); // Agregar un espacio en blanco con el estilo

        matchIndex++;
      }
    }

    return RichText(text: TextSpan(children: spans));
  }

  TextStyle _getStyleFromEscapeCode(String escapeCode) {
    // Se eliminan los corchetes y se divide el código en función de las letras
    List<String> codeParts = escapeCode.replaceAll('[', '').split('m');

    // Si hay partes de código válidas
    if (codeParts.isNotEmpty) {
      String colorCode = codeParts[0]; // Se obtiene el código de color

      switch (colorCode) {
        case '36': // Cyan
          return TextStyle(color: Colors.cyan);
        case '33': // Amarillo
          return TextStyle(color: Colors.yellow);
        default:
          return TextStyle();
      }
    }

    return TextStyle();
  }
}
