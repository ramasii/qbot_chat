import 'dart:developer';

import 'package:IslamBot/pages/pages.dart';
import 'package:flutter/material.dart';
import '../utils/allpackages.dart';
import '../qbotterminal.dart';

class LabelPage extends StatefulWidget {
  @override
  _LabelPageState createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  late List labeledItems = [];
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
    getLabeledItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            'Label Page',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: labeledItems.length != 0
            ? ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ObjectKey(labeledItems[index]),
                    confirmDismiss: (direction) async {
                      // Menampilkan konfirmasi dialog
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Hapus label ini?'),
                            content: Text(
                                'Label yang dihapus tidak bisa dikembalikan.'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
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
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
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
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      labeledItems.removeAt(index);
                      await saveLabeledItems();
                      await getLabeledItems(); // supaya variabel index tetap dinamis
                    },
                    child: ListTile(
                      onTap: () {
                        log('tap index $index, isi pesan: ${labeledItems[index]['listPesan'][0]['pesanObj']['pesan']}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailLabel(labelData: labeledItems[index],)));
                        /* showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(labeledItems[index]['labelName']),
                                        Container(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        IconButton(
                                          splashRadius: 25,
                                          icon: Icon(
                                            Icons.close,
                                            size: 17,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                titlePadding:
                                    EdgeInsets.fromLTRB(15, 15, 15, 15),
                                contentPadding: EdgeInsets.all(5),
                                content: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: AssetImage("images/bg.jpg"),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      children: List.generate(
                                        labeledItems[index]['listPesan'].length,
                                        (index2) {
                                          List sortedPesan = List.from(
                                              labeledItems[index]['listPesan']);
                                          sortedPesan.sort((a, b) {
                                            DateTime timeA = DateTime.parse(
                                                a['pesanObj']['time']);
                                            DateTime timeB = DateTime.parse(
                                                b['pesanObj']['time']);
                                            return timeA.compareTo(timeB);
                                          });

                                          Map pesanObj =
                                              sortedPesan[index2]['pesanObj'];

                                          return Row(
                                            mainAxisAlignment:
                                                pesanObj['fromUser']
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          100, 0, 0, 0),
                                                      blurRadius: 2,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                    bottomLeft: Radius.circular(
                                                        pesanObj['fromUser']
                                                            ? 8
                                                            : 0),
                                                    bottomRight:
                                                        Radius.circular(
                                                            pesanObj['fromUser']
                                                                ? 0
                                                                : 8),
                                                  ),
                                                  color: pesanObj['fromUser']
                                                      ? Color.fromARGB(
                                                          255, 231, 255, 219)
                                                      : Colors.white,
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                margin: EdgeInsets.only(
                                                    top: 2, bottom: 2),
                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                                  context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          135
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          125,
                                                ),
                                                child: BoldAsteris(
                                                    text: pesanObj['pesan']),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }); */
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            labelColors[labeledItems[index]['labelColor']],
                        radius: 25,
                        child: Icon(Icons.label_outline, color: Colors.white),
                      ),
                      title: Text(
                        labeledItems[index]['labelName'],
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                          '${labeledItems[index]['listPesan'].length} items'),
                    ),
                  );
                },
                itemCount: labeledItems.length,
              )
            : Center(
                child: Text(
                  'Anda belum menambahkan label',
                  style: TextStyle(color: Colors.grey),
                ),
              ));
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
