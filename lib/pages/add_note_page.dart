import 'dart:developer';

import 'package:IslamBot/pages/note_page.dart';
import 'package:flutter/material.dart';
import '../utils/allpackages.dart';

class AddNotePage extends StatefulWidget {
  final Map? noteToEdit;

  AddNotePage({
    Key? key,
    this.noteToEdit,
  }) : super(key: key);
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  List noteList = [];
  List colorList = [
    Color.fromARGB(255, 255, 155, 155),
    Color.fromARGB(255, 255, 217, 155),
    Color.fromARGB(255, 170, 255, 155),
    Color.fromARGB(255, 121, 255, 253),
    Color.fromARGB(255, 155, 158, 255),
    Color.fromARGB(255, 255, 155, 252)
  ];
  int colorIndex = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('in add note');
    if (widget.noteToEdit != null) {
      setState(() {
        titleController.text = widget.noteToEdit!['judul'];
        contentController.text = widget.noteToEdit!['konten'];
        colorIndex = widget.noteToEdit!['color'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(),
            ),
            (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Catatan', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => NotePage(),
                ),
                (route) => false),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () async {
            log('save note');
            var a = DateTime.now().toString();
            // tambah note baru
            if ((titleController.text.trim().isNotEmpty ||
                    contentController.text.trim().isNotEmpty) &&
                widget.noteToEdit == null) {
              await getNotesList();
              Map note = {
                "judul": titleController.text.trim(),
                "konten": contentController.text.trim(),
                "timeAdd": a,
                "timeEdited": a,
                "color": noteList.length > 5
                    ? sisabagi(noteList.length, 5)
                    : noteList.length
              };
              setState(() {
                noteList.add(note);
              });
              await saveNoteList();

              titleController.clear();
              contentController.clear();

              Fluttertoast.showToast(
                  msg: 'Catatan disimpan',
                  backgroundColor: Colors.green,
                  textColor: Colors.white);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotePage(),
                  ),
                  (route) => false);
            }
            // edit note
            else if ((titleController.text.trim().isNotEmpty ||
                    contentController.text.trim().isNotEmpty) &&
                widget.noteToEdit != null) {
              await getNotesList();
              Map note = {
                "judul": titleController.text.trim(),
                "konten": contentController.text.trim(),
                "timeEdited": DateTime.now().toString(),
                "timeAdd": widget.noteToEdit!['timeAdd'],
                "color": colorIndex,
              };
              // ambil index catatan yg diedit
              var idxToEdit = noteList.indexWhere((element) =>
                  element['timeAdd'] == widget.noteToEdit!['timeAdd']);

              // replace pada index tsb
              setState(() {
                noteList.replaceRange(idxToEdit, idxToEdit + 1, [note]);
              });

              // simpan
              await saveNoteList();

              titleController.clear();
              contentController.clear();

              Fluttertoast.showToast(
                  msg: 'Perubahan disimpan',
                  backgroundColor: Colors.green,
                  textColor: Colors.white);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotePage(),
                  ),
                  (route) => false);
            }
            // jika judul kosong
            else {
              Fluttertoast.showToast(
                  msg: 'Judul tidak boleh kosong',
                  textColor: Colors.black,
                  backgroundColor: Colors.yellow);
            }
          },
          borderRadius: BorderRadius.circular(30),
          child: Tooltip(
            message: 'Simpan',
            child: CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 30,
              child: Icon(
                Icons.save_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        colorList.length,
                        (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  colorIndex = index;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: colorList[index],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  if (index == colorIndex)
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                ],
                              ),
                            )),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: titleController,
                  cursorColor: Colors.teal,
                  autofocus: widget.noteToEdit ==
                      null, // kalo mau edit/view berarti 'true', kalo nambah berarti 'false'.
                  decoration: InputDecoration.collapsed(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    hintText: "Judul",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 143, 143, 143)), // Warna teks hint
                  ),
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 26), // Warna teks yang diketik
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: contentController,
                  cursorColor: Colors.teal,
                  maxLines: null, // baris tak terbatas
                  textInputAction: TextInputAction.newline,
                  autofocus: false, // supaya keyboard tidak muncul otomatis
                  decoration: InputDecoration.collapsed(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    hintText: "Masukkan catatan...",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(
                            255, 143, 143, 143)), // Warna teks hint
                  ),
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18), // Warna teks yang diketik
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // fungsi save notes
  saveNoteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('noteList', jsonEncode(noteList));
    log('saved noteList');
  }

  //fungsi sisa bagi
  sisabagi(int a, int b) {
    return a % b;
  }

  // fungsi ambil notes
  getNotesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? a = await prefs.getString('noteList');
    if (a != null) {
      setState(() {
        noteList = jsonDecode(a);
      });
      log('noteList ditemukan, length:${noteList.length}', name: 'getNoteList');
    } else {
      log('noteList tidak ditemukan', name: 'getNoteList');
    }
  }
}
