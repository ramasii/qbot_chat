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
  RegExp arabicRegex =
      RegExp(r'[\u0600-\u06FF]'); // regex untuk mendeteksi bahasa arab

  @override
  void initState() {
    super.initState();

    // pisah teks
    if (widget.text.length > 396 && isExpanded == false) {
      bagian1 =
          widget.text.substring(0, 396).replaceAll(RegExp(r'.{4}$'), "...");
      bagian2 = widget.text.substring(397, widget.text.length);
    } else {
      bagian1 = widget.text;
      bagian2 = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    //replace asteris double
    String ubahAsteris = bagian1.replaceAll(RegExp(r'\*\*'), "*");

    // split berdasarkan asteris
    List<String> words = ubahAsteris.split(RegExp(r'\*'));

    List<TextSpan> spans = List<TextSpan>.generate(words.length, (index) {
      if (index.isOdd) {
        // ini untuk teks bold
        return TextSpan(
          text: words[index],
          style: TextStyle(fontWeight: FontWeight.w700),
        );
      } else {
        // ini untuk deteksi arab
        List katas = words[index].split(
            RegExp(r'|\n \n(?=[\u0600-\u06FF])|(?<=[\u0600-\u06FF]|∞)\n \n'));

        // generate list(array) berisi textspan
        List<TextSpan> kataSpans =
            List<TextSpan>.generate(katas.length, (index) {
          
          // jika ini adalah teks arab
          if (arabicRegex.hasMatch(katas[index])) {
            return TextSpan(
                text: katas[index],
                style:
                    TextStyle(fontFamily: "LPMQ", fontSize: 28, height: 2.3));
          } 
          // jika bukan teks arab
          else {
            return TextSpan(
                text: katas[index],
                style: TextStyle(
                    fontFamily: "IslamBot", fontSize: 18, height: 1.5));
          }
        });

        // ingat, ini bagian else, jadi return nilai array yang mendeteksi teks arab berupa textSpan
        return TextSpan(children: kataSpans);
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
