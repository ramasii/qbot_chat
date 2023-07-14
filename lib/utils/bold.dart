import 'package:flutter/material.dart';
import '../utils/allpackages.dart';

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
      bagian1 = widget.text
          .substring(0, 396)
          .replaceAll(RegExp(r'.{4}$'), "..."); // diakhiri titik-titik (...)
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

    // split berdasarkan teks arab, outpunya List<String>
    List<String> arabs = ubahAsteris.split(RegExp(
        r'(\n|\n \n(\s|)|\n\n)(?=(|{)[\u0600-\u06FF])|(?<=[\u0600-\u06FF](|})|∞|\s)(\n \n|\n|\n\n)'));

    // List untuk ditampilkan di akhir, jangan lupa digabung dengan myReadmore()
    List<Widget> listRichText = List<Widget>.generate(arabs.length, (index) {
      // ubah font arab
      if (arabicRegex.hasMatch(arabs[index]) && index > 0) { // diberi index > 0 untuk antisipasi
        return RichText(
            // textAlign: TextAlign.end, // alignment
            textDirection: TextDirection.rtl, // direction
            text: TextSpan(
              children: [
                WidgetSpan(
                    child: Container(
                  height: 20,
                )),
                TextSpan(
                  text: arabs[index],
                  style: TextStyle(
                      fontFamily: AppSettings.arabicFont,
                      fontSize: AppSettings.arabicTextSize,
                      height: AppSettings.arabicTextSize / 10,
                      color: Colors.black),
                ),
                WidgetSpan(
                    child: Container(
                  height: 20,
                ))
              ],
            ));
      } else {
        // split berdasarkan asteris
        List<String> words = arabs[index].split(RegExp(r'\*'));

        List<TextSpan> spans = List<TextSpan>.generate(words.length, (index) {
          if (index.isOdd) {
            // ini untuk teks bold
            return TextSpan(
              text: words[index],
              style: TextStyle(fontWeight: FontWeight.w700),
            );
          } else {
            return TextSpan(
              text: words[index],
              style: TextStyle(
                fontFamily: "IslamBot",
              ),
            );
          }
        });

        return RichText(
          text: TextSpan(
              children: spans,
              style: TextStyle(
                  color: Colors.black, fontSize: AppSettings.regularTextSize)),
        );
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
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: AppSettings.regularTextSize,
                    fontFamily: "IslamBot"),
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

    // listRichtext + myReadmore, digabung dengan readmore
    listRichText.add(myReadmore());

    // return Column -> RichText & readmore widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listRichText,
    );
  }
}
