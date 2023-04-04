import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:readmore/readmore.dart';

class BoldAsteris extends StatelessWidget {
  final String text;
  bool isExpanded = false;

  BoldAsteris({required this.text});

  @override
  Widget build(BuildContext context) {

    String ubahAsteris = text.replaceAll(RegExp(r'\*\*'), "*");
    List<String> words = ubahAsteris.split('*');
    List<TextSpan> spans = List<TextSpan>.generate(words.length, (index) {
      if (index.isOdd) {
        return TextSpan(
          text: words[index],
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      } else {
        return TextSpan(text: words[index]);
      }
    });
    return RichText(
      softWrap: true,
      overflow: TextOverflow.clip,
      text: TextSpan(
          children: spans, style: TextStyle(color: Colors.black, fontSize: 17)),
    );
  }
}
