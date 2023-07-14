import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:IslamBot/utils/allpackages.dart';
import 'pages.dart';
import 'package:flutter_excel/excel.dart';

enum LabeledOptions { copy, export, edit, delete }

class DetailLabel extends StatefulWidget {
  Map labelData;
  final int indexLabel;

  DetailLabel({required this.labelData, required this.indexLabel});

  @override
  _DetailLabelState createState() => _DetailLabelState();
}

class _DetailLabelState extends State<DetailLabel> {
  late List pesanArray = [];
  List selectedMsg = [];
  late List labeledItems = [];
  var _popupMenuItemIndex = 0;

  @override
  void initState() {
    super.initState();
    log('in detail label page');

    getPesanArray();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedMsg.isNotEmpty) {
          setState(() {
            selectedMsg.clear();
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LabelPage()),
              (route) => false);
        }

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 58, 86, 100),
            title: Text(
              '${widget.labelData['labelName']}',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LabelPage()),
                      (Route<dynamic> route) => false,
                    )),
            actions: [
              if (selectedMsg.isNotEmpty)
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Hapus pesan ini?'),
                            content: Text(
                                'Anda dapat menambahkan pesan ini lagi selama pesan masih ada.'),
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
                                  await getLabeledItems();
                                  if (labeledItems.isNotEmpty) {
                                    log('isi selectMsg: $selectedMsg');
                                    log('isi labeleditems: $labeledItems');
                                    selectedMsg.forEach((element) {
                                      log('yang dihapus index-$element: ${labeledItems[widget.indexLabel]['listPesan']}');
                                      setState(() {
                                        List listPesan =
                                            labeledItems[widget.indexLabel]
                                                ['listPesan'];
                                        listPesan.removeWhere(
                                            (e) => e['pesanObj'] == element);
                                      });
                                    });
                                    selectedMsg.clear();
                                    await saveLabeledItems();
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailLabel(
                                        labelData:
                                            labeledItems[widget.indexLabel],
                                        indexLabel: widget.indexLabel,
                                      ),
                                    ),
                                  );
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
                    )),
              if (selectedMsg.isNotEmpty)
                IconButton(
                    onPressed: () async {
                      log('copy Msg');
                      List listMsgToCopy = [];
                      String joinedListMsgToCopy = '';

                      selectedMsg.forEach((msgTime) {
                        // menemukan index objek pesan yang time nya sama
                        int indexPesan = pesanArray.indexWhere(
                          (element) => element['time'] == msgTime,
                        );
                        listMsgToCopy.add(pesanArray[indexPesan]['pesan']);
                      });

                      joinedListMsgToCopy = listMsgToCopy.join("\n \n");
                      await Clipboard.setData(
                          ClipboardData(text: joinedListMsgToCopy));

                      Fluttertoast.showToast(
                          msg: 'Pesan disalin',
                          backgroundColor: Colors.green,
                          textColor: Colors.white);

                      setState(() {
                        selectedMsg.clear();
                      });
                    },
                    icon: Icon(
                      Icons.copy_rounded,
                      color: Colors.white,
                    )),
              if (selectedMsg.isNotEmpty) ExportToExcel(context),
              if (selectedMsg.isEmpty)
                PopupMenuButton(
                    color: Colors.white,
                    onSelected: (value) {
                      print('klik {$value} di popup menu, pojok kanan atas');
                      _onMenuItemSelected(value as int);
                    },
                    itemBuilder: (ctx) => [
                          _buildPopupMenuItem('Salin Pesan', Icons.copy_rounded,
                              LabeledOptions.copy.index),
                          _buildPopupMenuItem(
                              'Ekspor Pesan',
                              Icons.file_upload_rounded,
                              LabeledOptions.export.index),
                          _buildPopupMenuItem('Edit Label', Icons.edit_rounded,
                              LabeledOptions.edit.index),
                          _buildPopupMenuItem('Hapus Label',
                              Icons.delete_rounded, LabeledOptions.delete.index)
                        ])
            ],
          ),
          body: Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              child: widget.labelData['listPesan'].isEmpty
                  ? Center(
                      child: Text(
                        'Anda belum menambahkan pesan untuk label ini',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          widget.labelData['listPesan'].length,
                          (index2) {
                            List sortedPesan =
                                List.from(widget.labelData['listPesan']);
                            sortedPesan.sort((a, b) {
                              DateTime timeA = DateTime.parse(a['pesanObj']);
                              DateTime timeB = DateTime.parse(b['pesanObj']);
                              return timeA.compareTo(timeB);
                            });

                            String msgTime = sortedPesan[index2]['pesanObj'];
                            Map pesanObj = {};

                            // menemukan index objek pesan yang time nya sama
                            int indexPesan = pesanArray.indexWhere(
                              (element) => element['time'] == msgTime,
                            );
                            if (indexPesan != -1) {
                              setState(() {
                                pesanObj = pesanArray[indexPesan];
                              });
                            }

                            // log('pesan array: ${pesanObj['pesan']}');

                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      selectedMsg.contains(msgTime) ? 255 : 0,
                                      188,
                                      225,
                                      255),
                                  borderRadius: BorderRadius.circular(10)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onLongPress: () {
                                  // jika sedang tidak memilih
                                  if (selectedMsg.isEmpty) {
                                    log('start milih');
                                    setState(() {
                                      selectedMsg.add(msgTime);
                                    });
                                  }
                                },
                                onTap: () {
                                  log('tap pesan index  ke-$index2, time: ${msgTime}');
                                  // jika sedang tidak memilih pesan
                                  if (selectedMsg.isEmpty) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          messageStamp: msgTime,
                                          arguments: ChatPageArguments(
                                            peerId: '111',
                                            peerAvatar: 'images/app_icon.png',
                                            peerNickname: 'IslamBot',
                                          ),
                                        ),
                                      ),
                                      (route) =>
                                          false, // Menghapus semua halaman di atasnya dalam stack halaman
                                    );
                                  } else {
                                    // jika sudah dipilih, maka un-select
                                    if (selectedMsg.contains(msgTime)) {
                                      setState(() {
                                        selectedMsg.remove(msgTime);
                                      });
                                      log('index $msgTime removed from selectedMsg');
                                    } else {
                                      setState(() {
                                        selectedMsg.add(msgTime);
                                      });
                                      log('add index ${msgTime}');
                                    }
                                  }
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 5, 5, 5),
                                              child: pesanInLabel(
                                                  pesanObj: pesanObj),
                                            ),
                                            Divider(
                                              thickness: 2,
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              indent: 20,
                                              endIndent: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ))),
    );
  }

  IconButton ExportToExcel(BuildContext context) {
    return IconButton(
        onPressed: () async {
          log('export excel Msg');
          List listMsgForExcel = [];

          selectedMsg.forEach((msgTime) {
            // menemukan index objek pesan yang time nya sama
            int indexPesan = pesanArray.indexWhere(
              (element) => element['time'] == msgTime,
            );
            listMsgForExcel.add(pesanArray[indexPesan]);
          });

          await exportExcelNew(listMsgForExcel);
        },
        icon: Icon(
          Icons.file_download_rounded,
          color: Colors.white,
        ));
  }

  // fungsi ambil pesan
  getPesanArray() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? items = await prefs.getString('pesanArray');
    if (items != null) {
      List mapList = jsonDecode(items);
      print('------------ get pesan array');
      setState(() {
        pesanArray = mapList;
      });
    } else {
      print('Nilai untuk pesanArray tidak ditemukan');
    }
  }

  // fungsi save labeledItems
  saveLabeledItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('labeledItems', jsonEncode(labeledItems));
    log('saved labeledItems');
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

  //widget popup menu button
  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.teal,
          ),
          Container(
            width: 10,
          ),
          Text(title),
        ],
      ),
    );
  }

  // fungsi jika select di popup menu
  _onMenuItemSelected(int value) async {
    setState(() {
      _popupMenuItemIndex = value;
    });

    // copy
    if (value == LabeledOptions.copy.index) {
      log('copy pesan');
    }

    // export
    else if (value == LabeledOptions.export.index) {
      log('export pesan');
      List listMsgForExcel = [];
      List listPesan = widget.labelData['listPesan'];

      await getPesanArray();

      listPesan.forEach((element) {
        // menemukan index objek pesan yang time nya sama
        int indexPesan = pesanArray.indexWhere(
          (element2) => element2['time'] == element['pesanObj'],
        );
        listMsgForExcel.add(pesanArray[indexPesan]);
      });

      // expor to excel new
      await exportExcelNew(listMsgForExcel);
    }

    // edit
    else if (value == LabeledOptions.edit.index) {
      log('edit nama label');
    }

    // hapus
    else if (value == LabeledOptions.delete.index) {
      log('delete label');
    }
  }

  // expor excel new
  exportExcelNew(List listMsgForExcel) async {
    var selectedData = listMsgForExcel
        .map((e) => {
              "pengirim": e["fromUser"] ? "Anda" : "Islambot",
              "pesan": e["pesan"],
              "time": e["time"]
            })
        .toList();

    // membuat file excel dan menambahkan data pada sheet
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    List<String> header = ["pengirim", "pesan", "time"];
    sheetObject.appendRow(header);
    for (var i = 0; i < selectedData.length; i++) {
      List<dynamic> row = [];
      for (var j = 0; j < header.length; j++) {
        row.add(selectedData[i][header[j]]);
      }
      sheetObject.appendRow(row);
    }

    // Mendapatkan path Documents/IslamBot pada memori internal
    String tgl = DateFormat('yyyyMMdd').format(DateTime.now());
    String filePath =
        "/storage/emulated/0/Documents/IslamBot/IslamBot-Excel-$tgl.xlsx";

    // Mengecek apakah folder sudah ada, jika belum maka buat folder tersebut
    if (!await Directory('/storage/emulated/0/Documents/IslamBot').exists()) {
      await Directory('/storage/emulated/0/Documents/IslamBot')
          .create(recursive: true);
    }

    // izin akses memori
    var statusAkses = await Permission.storage.request();
    if (statusAkses.isGranted) {
      // Menulis file excel ke direktori tersebut
      File file = File(filePath);
      await file.writeAsBytes(excel.encode()!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Disimpan di memori internal/Documents/IslamBot/IslamBot-Excel-$tgl.xlsx"),
      ));
    } else {
      // Tampilkan snackbar dengan pesan izin ditolak
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Izin penyimpanan ditolak'),
          backgroundColor: Colors.red,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
    }
  }
}

class pesanInLabel extends StatelessWidget {
  const pesanInLabel({
    super.key,
    required this.pesanObj,
  });

  final Map pesanObj;

  @override
  Widget build(BuildContext context) {
    return

        // Text('pesanTime: $pesanObj');
        pesanObj['fromUser'] != null
            ? Text.rich(
                TextSpan(
                  children: [
                    // teks pengirim
                    TextSpan(
                      text: '${pesanObj['fromUser'] ? 'Anda' : 'IslamBot'}: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // teks pesan
                    if (pesanObj['share'] == true)
                      WidgetSpan(
                        child: Image.network(
                          pesanObj['imgUrl'],
                          width: 180,
                        ),
                      )
                    else
                      TextSpan(
                        text: pesanObj['pesan'].replaceAll(RegExp(r'\*'), ''),
                      ),
                  ],
                ),
                maxLines: 6,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )
            : Container();
  }
}
