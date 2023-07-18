import 'dart:developer';

import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController searchController = TextEditingController();
  List listColors = [
    Color.fromARGB(255, 255, 155, 155),
    Color.fromARGB(255, 255, 217, 155),
    Color.fromARGB(255, 170, 255, 155),
    Color.fromARGB(255, 121, 255, 253),
    Color.fromARGB(255, 155, 158, 255),
    Color.fromARGB(255, 255, 155, 252)
  ];
  @override
  void initState() {
    super.initState();
    log('in NotePage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text('Catatan', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 58, 86, 100),
                padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                child: searchWidget(searchController: searchController),
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                        color: listColors[1],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('Judul', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), Text('sebagian isi\n1\n2\n3asdas\n4', maxLines: 4, overflow: TextOverflow.ellipsis,)],
                      ),
                    ),
                  ))
                ],
              )
            ],
          ),
        ));
  }
}

class searchWidget extends StatelessWidget {
  const searchWidget({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        height: 50,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 83, 123, 141),
            borderRadius: BorderRadiusDirectional.circular(60)),
        child: Align(
          child: TextField(
            controller: searchController,
            cursorColor: Colors.teal,
            maxLines: 3,
            decoration: InputDecoration.collapsed(
              floatingLabelAlignment: FloatingLabelAlignment.start,
              hintText: "Cari catatan...",
              hintStyle: TextStyle(color: Color.fromARGB(255, 186, 186, 186)), // Warna teks hint
            ),
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18), // Warna teks yang diketik
          ),
        ));
  }
}
