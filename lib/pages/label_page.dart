import 'dart:developer';

import 'package:IslamBot/pages/pages.dart';
import 'package:flutter/material.dart';
import '../utils/allpackages.dart';
import '../qbotterminal.dart';

class LabelPage extends StatefulWidget {
  /* final List pesanArray;
  LabelPage({required this.pesanArray}); */

  @override
  _LabelPageState createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  late List labeledItems = [];
  List selectedLabel = [];
  List labelColors = [
    Color.fromARGB(255, 255, 155, 155),
    Color.fromARGB(255, 255, 217, 155),
    Color.fromARGB(255, 170, 255, 155),
    Color.fromARGB(255, 121, 255, 253),
    Color.fromARGB(255, 155, 158, 255),
    Color.fromARGB(255, 255, 155, 252)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('in label page');
    getLabeledItems();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController newLabelController = TextEditingController();

    return WillPopScope(
      onWillPop: () async {
        if (selectedLabel.isNotEmpty) {
          setState(() {
            selectedLabel.clear();
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  arguments: ChatPageArguments(
                    peerId: '111',
                    peerAvatar: 'images/app_icon.png',
                    peerNickname: 'IslamBot',
                  ),
                ),
              ),
              (route) => false);
        }

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 58, 86, 100),
            title: Text(
              'Labels',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      arguments: ChatPageArguments(
                        peerId: '111',
                        peerAvatar: 'images/app_icon.png',
                        peerNickname: 'IslamBot',
                      ),
                    ),
                  ),
                  (route) => false),
            ),
            actions: [
              if (selectedLabel.isNotEmpty)
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Hapus label ini?'),
                            content: Text(
                                'Label yang dihapus tidak bisa dikembalikan.'),
                            actions: [
                              TextButton(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  log('press hapus');
                                  log('labeledItems: $labeledItems');
                                  selectedLabel.sort();
                                  setState(() {
                                    for (var e in selectedLabel) {
                                      labeledItems.removeWhere((element) => element['time'] == e);
                                    }
                                  });

                                  selectedLabel.clear();
                                  saveLabeledItems();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ))
            ],
          ),
          floatingActionButton: selectedLabel.isEmpty
              ? InkWell(
                  onTap: () {
                    log('new label');
                    String labelName = '';
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Buat Label Baru'),
                          content: TextField(
                            controller: newLabelController,
                            onChanged: (value) {
                              labelName = value;
                            },
                            decoration: InputDecoration(
                                hintText: 'Masukkan nama label',
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 58, 86, 100))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 58, 86, 100)))),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (labelName.isNotEmpty) {
                                  await getLabeledItems();
                                  setState(() {
                                    labeledItems.add({
                                      "labelName": labelName,
                                      "labelColor": labeledItems.length > 5
                                          ? sisabagi(labeledItems.length, 5)
                                          : labeledItems.length,
                                      "listPesan": [],
                                                            "time":DateTime.now().toString()
                                    });
                                  });
                                  await saveLabeledItems();
                                  await getLabeledItems();

                                  log('sukses melabel pesan: ${labeledItems.last}');
                                  Fluttertoast.showToast(
                                      msg: 'Disimpan dengan label "$labelName"',
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Nama label tidak boleh kosong',
                                      textColor: Colors.black,
                                      backgroundColor: Colors.yellow);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  radius: 30,
                  borderRadius: BorderRadius.circular(30),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green[400],
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
          body: labeledItems.length != 0
              ? Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            // jika tidak sedang memilih pesan, maka pesan akan terpilih
                            if (selectedLabel.isEmpty) {
                              log('start milih');
                              setState(() {
                                selectedLabel.add(labeledItems[index]['time']);
                              });
                            }
                          },
                          onTap: () {
                            log('tap index $index');
                            // jika tidak sedang memilih pesan, maka akan masuk ke detail label
                            if (selectedLabel.isEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailLabel(
                                    labelData: labeledItems[index],
                                    indexLabel: index,
                                  ),
                                ),
                              );
                            } else {
                              // jika index sudah ada di selectedItem, hapus dari list
                              if (selectedLabel.contains(labeledItems[index]['time'])) {
                                setState(() {
                                  selectedLabel.remove(labeledItems[index]['time']);
                                });
                                log('index $index removed from labeledItems');
                              } else {
                                setState(() {
                                  selectedLabel.add(labeledItems[index]['time']);
                                });
                                log('add index ${index}');
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: CircleAvatar(
                                      backgroundColor: labelColors[
                                          labeledItems[index]['labelColor']],
                                      radius: 25,
                                      child: Icon(Icons.label_outline,
                                          color: Colors.white),
                                    ),
                                  ),
                                  // centang saat dipilih
                                  selectedLabel.contains(labeledItems[index]['time'])
                                      ? Container(
                                          padding: EdgeInsets.all(8),
                                          child: Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.green,
                                                  child: Icon(
                                                    Icons.check_rounded,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      labeledItems[index]['labelName'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      '${labeledItems[index]['listPesan'].length} messages',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Divider(
                                      endIndent: 20,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: labeledItems.length,
                    ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Gunakan label untuk memilah pesan. Tekan dan tahan di pesan untuk memberi label.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              )
              : Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text(
                      'Gunakan label untuk memilah pesan. Tekan dan tahan di pesan untuk memberi label.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
    );
  }

  //fungsi sisa bagi
  sisabagi(int a, int b) {
    return a % b;
  }

  // fungsi get labeledItems
  getLabeledItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? a = await prefs.getString('labeledItems');
    if (a != null) {
      setState(() {
        labeledItems = jsonDecode(a);
      });
      log('labeledItems ditemukan, length:${labeledItems.length}',
          name: 'getLabeledItems');
    } else {
      log('labeledItems tidak ditemukan', name: 'getLabeledItems');
    }
  }

  // fungsi save labeledItems
  saveLabeledItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('labeledItems', jsonEncode(labeledItems));
    log('saved labeledItems');
  }
}
