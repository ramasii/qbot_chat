import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            'About Us',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'images/logo_ubig.png',
                    width: 200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text("UBIG.CO.ID adalah startup IT yang fokus menyediakan platform dan konten Big Data dengan berbagai kategori data (harga, berita, gaya hidup, dsb)."),
                ),
              ],
            ),
          ),
        ));
  }
}
