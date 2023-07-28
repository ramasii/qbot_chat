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
    Color.fromARGB(255, 240, 153, 137),
    Color.fromARGB(255, 123, 195, 250),
    Color.fromARGB(255, 247, 214, 81),
    Color.fromARGB(255, 215, 176, 236),
    Color.fromARGB(255, 119, 200, 181),
    Color.fromARGB(255, 240, 160, 249),
    Color.fromARGB(255, 160, 249, 255),
    Color.fromARGB(255, 205, 171, 64),
    Color.fromARGB(255, 112, 124, 201),
    Color.fromARGB(255, 218, 230, 106),
    Color.fromARGB(255, 95, 206, 221),
    Color.fromARGB(255, 246, 198, 199),
    Color.fromARGB(255, 247, 214, 81),
    Color.fromARGB(255, 228, 85, 79),
    Color.fromARGB(255, 71, 159, 235),
    Color.fromARGB(255, 156, 227, 78),
    Color.fromARGB(255, 243, 178, 63),
    Color.fromARGB(255, 190, 232, 252),
    Color.fromARGB(255, 158, 166, 249),
    Color.fromARGB(255, 141, 107, 201),
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
              AppLocalizations.of(context)!.labels,
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
                            title: Text(AppLocalizations.of(context)!.dltThisLbl),
                            content: Text(
                                AppLocalizations.of(context)!.dltLblConfrm),
                            actions: [
                              TextButton(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
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
                                    AppLocalizations.of(context)!.delete,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  log('press hapus');
                                  log('labeledItems: $labeledItems');
                                  selectedLabel.sort();
                                  setState(() {
                                    for (var e in selectedLabel) {
                                      labeledItems.removeWhere(
                                          (element) => element['time'] == e);
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
                          title: Text(AppLocalizations.of(context)!.addNewLabel),
                          content: TextField(
                            controller: newLabelController,
                            onChanged: (value) {
                              labelName = value;
                            },
                            decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.newLabelHint,
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
                                  AppLocalizations.of(context)!.cancel,
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
                                      "labelColor": labeledItems.length > 9
                                          ? sisabagi(labeledItems.length, 9)
                                          : labeledItems.length,
                                      "listPesan": [],
                                      "time": DateTime.now().toString()
                                    });
                                  });
                                  await saveLabeledItems();
                                  await getLabeledItems();

                                  log('sukses melabel pesan: ${labeledItems.last}');
                                  Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!.successAddToLabel,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!
                                          .labelNameDontEmpty,
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
                                  AppLocalizations.of(context)!.save,
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
                  child: Tooltip(
                    message: AppLocalizations.of(context)!.addLabel,
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
                              if (selectedLabel
                                  .contains(labeledItems[index]['time'])) {
                                setState(() {
                                  selectedLabel
                                      .remove(labeledItems[index]['time']);
                                });
                                log('index $index removed from labeledItems');
                              } else {
                                setState(() {
                                  selectedLabel
                                      .add(labeledItems[index]['time']);
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
                                  selectedLabel
                                          .contains(labeledItems[index]['time'])
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
                                      '${labeledItems[index]['listPesan'].length} pesan',
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
                        AppLocalizations.of(context)!.labelInfo,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text(
                      AppLocalizations.of(context)!.labelInfo,
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
        labeledItems.sort((a, b) => a['labelName']
            .toLowerCase()
            .compareTo(b['labelName'].toLowerCase()));
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
