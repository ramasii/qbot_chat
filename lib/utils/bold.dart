import 'package:flutter/material.dart';

class BoldAsteris extends StatefulWidget {
  final String text;

  BoldAsteris({required this.text});

  @override
  _BoldAsterisState createState() => _BoldAsterisState();
}

class _BoldAsterisState extends State<BoldAsteris> {
  // variable
  late bool isExpanded = false;
  late String bagian1;
  late String bagian2;

  @override
  void initState() {
    super.initState();

    // pisah teks
    if (widget.text.length > 550 && isExpanded == false) {
      bagian1 = widget.text.substring(0, 550).replaceAll(RegExp(r'.{4}$'), "...");
      bagian2 = widget.text.substring(551, widget.text.length);
    } else {
      bagian1 = widget.text;
      bagian2 = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // bold text
    String ubahAsteris = bagian1.replaceAll(RegExp(r'\*\*'), "*");
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

    // widget baca selengakpnya
    Widget myReadmore() {
      return bagian2 == ""
          ? Container(
              height: 0,
              width: 0,
            )
          : InkWell(
              child: Text(
                'Baca selengkapnya',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
              onTap: () {
                print('object');
                setState(() {
                  isExpanded = true;
                  bagian1 = widget.text;
                  bagian2 = "";
                });
              },
            );
    }

    // return Column -> RichText & readmore widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: TextSpan(
              children: spans,
              style: TextStyle(color: Colors.black, fontSize: 17)),
        ),
        myReadmore()
      ],
    );
  }
}
