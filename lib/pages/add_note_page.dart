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
    Color.fromARGB(255, 244, 237, 178),
    Color.fromARGB(255, 223, 243, 179),
    Color.fromARGB(255, 192, 242, 177),
    Color.fromARGB(255, 238, 195, 236),
    Color.fromARGB(255, 183, 228, 244),
    Color.fromARGB(255, 196, 208, 242),
    Color.fromARGB(255, 186, 243, 220),
    Color.fromARGB(255, 238, 170, 190),
    Color.fromARGB(255, 241, 241, 241),
  ];
  int colorIndex = 0;
  bool isEditMode = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('in add note');
    if (widget.noteToEdit != null) {
      // noteToEdit ada isinya
      setState(() {
        titleController.text = widget.noteToEdit!['judul'];
        contentController.text = widget.noteToEdit!['konten'];
        colorIndex = widget.noteToEdit!['color'];
        isEditMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEditMode == false || widget.noteToEdit == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(),
              ),
              (route) => false);
        } else {
          setState(() {
            isEditMode = false;
          });
        }
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
          actions: widget.noteToEdit != null
              ? [
                  IconButton(
                      splashRadius: 25,
                      tooltip: isEditMode ? "Batal" : "Edit",
                      onPressed: () {
                        log('modeEdit');
                        setState(() {
                          if (isEditMode) {
                            isEditMode = false;
                          } else {
                            isEditMode = true;
                          }
                        });
                      },
                      icon: Icon(
                        isEditMode ? Icons.cancel : Icons.edit,
                        color: Colors.white,
                      )),
                  // tombol save
                  if (isEditMode)
                    IconButton(
                        tooltip: "Simpan",
                        splashRadius: 25,
                        onPressed: () async {
                          log('save note (appbar)');
                          await svFuncButton();
                        },
                        icon: Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                        )),
                  if (isEditMode == false)
                    IconButton(
                        tooltip: 'Salin Catatan',
                        onPressed: () async {
                          log('copy note');
                          await Clipboard.setData(ClipboardData(
                              text:
                                  '${widget.noteToEdit!['judul']}\n-----------------\n${widget.noteToEdit!['konten']}'));
                        },
                        icon: Icon(
                          Icons.copy,
                          color: Colors.white,
                        )),
                  if (isEditMode == false)
                    IconButton(
                        tooltip: 'Bagikan',
                        onPressed: () async {
                          log('share note');
                          await Share.share(
                              '${widget.noteToEdit!['judul']}\n-----------------\n${widget.noteToEdit!['konten']}',
                              subject: '${widget.noteToEdit!['judul']}');
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ))
                ]
              : [],
        ),
        floatingActionButton:
            isEditMode ? _floatingActionBtn(context) : Container(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (isEditMode)
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                        margin:
                                            EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  enabled: isEditMode,
                  controller: titleController,
                  cursorColor: Colors.teal,
                  maxLines: null,
                  autofocus: widget.noteToEdit ==
                      null, // kalo mau edit/view berarti 'true', kalo nambah berarti 'false'.
                  decoration: InputDecoration.collapsed(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    hintText: "Judul",
                    hintStyle: TextStyle(
                        color: Color.fromARGB(255, 143, 143, 143),
                        fontWeight: FontWeight.bold), // Warna teks hint
                  ),
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 26,
                      fontWeight: FontWeight.bold), // Warna teks yang diketik
                ),
              ),
              Divider(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  enabled: isEditMode,
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

  InkWell _floatingActionBtn(BuildContext context) {
    return InkWell(
      onTap: () async {
        log('save note');
        await svFuncButton();
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
    );
  }

  // fungsi button save note
  svFuncButton() async {
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
        "color": colorIndex
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
    else if (titleController.text.trim().isNotEmpty &&
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
      var idxToEdit = noteList.indexWhere(
          (element) => element['timeAdd'] == widget.noteToEdit!['timeAdd']);

      // replace pada index tsb
      setState(() {
        noteList.replaceRange(idxToEdit, idxToEdit + 1, [note]);
      });

      // simpan
      await saveNoteList();

      Fluttertoast.showToast(
          msg: 'Perubahan disimpan',
          backgroundColor: Colors.green,
          textColor: Colors.white);
      setState(() {
        isEditMode = false;
      });
    }
    // jika judul kosong
    else {
      Fluttertoast.showToast(
          msg: 'Judul tidak boleh kosong',
          textColor: Colors.black,
          backgroundColor: Colors.yellow);
    }
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
