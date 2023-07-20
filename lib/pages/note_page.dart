import 'dart:developer';

import 'package:IslamBot/pages/pages.dart';
import 'package:flutter/material.dart';
import '../utils/allpackages.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController searchController = TextEditingController();
  List noteList =
      []; // {"judul":"String", "konten":"String Multiline\n1\n2\n3 last", "timeAdd":"DateTime().now().toString", "color":0}
  List filteredNote = [];
  List colorList = [
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
    getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context, ChatPageRoute(), (route) => false);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Catatan', style: TextStyle(color: Colors.white)),
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 58, 86, 100),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, ChatPageRoute(), (route) => false),
            ),
          ),
          floatingActionButton: AddNoteButton(), // widget custom
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 58, 86, 100),
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 83, 123, 141),
                        borderRadius: BorderRadiusDirectional.circular(60)),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        onSearchTextChanged(value);
                      },
                      cursorColor: Colors.teal,
                      maxLines: 1,
                      autofocus: false, // supaya keyboard tidak muncul otomatis
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        prefixIconColor: Color.fromARGB(255, 186, 186, 186),

                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,

                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        hintText: "Cari catatan...",

                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 186, 186, 186),
                            fontSize: 18), // Warna teks hint
                      ),
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18), // Warna teks yang diketik
                    ),
                  ),
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return noteList.isNotEmpty
                      ? Column(
                          children: List.generate(filteredNote.length, (index) {
                            log(filteredNote.length.toString());
                            return Row(
                              children: [
                                Expanded(
                                    // item catatan
                                    child: Card(
                                  color:
                                      colorList[filteredNote[index]['color']],
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  child: Container(
                                    // padding: EdgeInsets.all(15),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        log('view note idx $index');

                                        // view or edit
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddNotePage(
                                                    noteToEdit:
                                                        filteredNote[index],
                                                  )),
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 10, 15, 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  filteredNote[index]
                                                              ['judul'] !=
                                                          ''
                                                      ? Text(
                                                          filteredNote[index]
                                                              ['judul'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        )
                                                      : Container(),
                                                  filteredNote[index]
                                                              ['konten'] !=
                                                          ''
                                                      ? Text(
                                                          filteredNote[index]
                                                              ['konten'],
                                                          maxLines: 4,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : Container(),
                                                      Divider(color: Color.fromARGB(0, 0, 0, 0),),
                                                  Text(filteredNote[index]
                                                              ['timeAdd'] ==
                                                          filteredNote[index]
                                                              ['timeEdited']
                                                      ? 'Ditambahkan ${filteredNote[index]['timeEdited'].toString().replaceAll(RegExp(r'(?=\.).+'), '')}'
                                                      : 'Diedit ${filteredNote[index]['timeEdited'].toString().replaceAll(RegExp(r'(?=\.).+'), '')}',
                                                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color.fromARGB(255, 138, 138, 138)),)
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              tooltip: 'Hapus',
                                              splashRadius: 25,
                                              onPressed: () async {
                                                // temukan indexnya
                                                var indexToDelete = filteredNote
                                                    .indexWhere((element) =>
                                                        element['timeAdd'] ==
                                                        filteredNote[index]
                                                            ['timeAdd']);

                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Hapus Catatan ini?'),
                                                      content: Text(
                                                          'Catatan yang dihapus tidak bisa dikembalikan.'),
                                                      actions: [
                                                        TextButton(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                              'Batal',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                              'Hapus',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            log('delete index: $indexToDelete');

                                                            setState(() {
                                                              noteList.removeAt(
                                                                  indexToDelete);
                                                            });
                                                            await saveNoteList();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.close,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            );
                          }),
                        )
                      : Center(
                          heightFactor: 10,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Anda belum menambahkan catatan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                })
              ],
            ),
          )),
    );
  }

  MaterialPageRoute<dynamic> ChatPageRoute() {
    return MaterialPageRoute(
      builder: (context) => ChatPage(
        arguments: ChatPageArguments(
          peerId: '111',
          peerAvatar: 'images/app_icon.png',
          peerNickname: 'IslamBot',
        ),
      ),
    );
  }

  // fungsi cari note
  void onSearchTextChanged(String text) {
    setState(() {
      filteredNote = noteList
          .where((element) =>
              element['judul']
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element['konten']
                  .toString()
                  .toLowerCase()
                  .contains(text.toLowerCase()))
          .toList();
    });
  }

  getNotesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? a = await prefs.getString('noteList');
    if (a != null) {
      setState(() {
        noteList = jsonDecode(a);
        noteList.sort((a, b) {
          DateTime timeA = DateTime.parse(a['timeEdited'] ?? '0');
          DateTime timeB = DateTime.parse(b['timeEdited'] ?? '0');
          return timeB.compareTo(timeA); // Mengurutkan dari terbaru ke terlama
        });
      });
      log('noteList ditemukan, length:${noteList.length}', name: 'getNoteList');
      setState(() {
        filteredNote = noteList;
      });
    } else {
      log('noteList tidak ditemukan', name: 'getNoteList');
    }
  }

  // fungsi save notes
  saveNoteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('noteList', jsonEncode(noteList));
    log('saved noteList');
  }
}

class AddNoteButton extends StatelessWidget {
  const AddNoteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('add note');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNotePage()),
        );
      },
      borderRadius: BorderRadius.circular(30),
      child: Tooltip(
        message: 'Tambah Catatan',
        child: CircleAvatar(
          backgroundColor: Colors.teal,
          radius: 30,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
