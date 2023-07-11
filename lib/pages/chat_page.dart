import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

// masukkan packages lewat allpackages.dart
import '../utils/allpackages.dart';
import 'pages.dart';
import '../qbotterminal.dart';

enum Options { clear, exit, export, about, settings, import, labels }

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.arguments, this.messageStamp = ''})
      : super(key: key);

  final ChatPageArguments arguments;
  var messageStamp;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";

  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";
  bool pakaiTeks = false;
  bool showUpButton = false;
  bool listening = false;
  bool loadingOcr = false;
  bool selectItem = false;
  bool speaking = false;
  var _popupMenuItemIndex = 0;

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textLabelNameController = TextEditingController();
  late AutoScrollController _autoScrollController;
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final FocusNode focusNode = FocusNode();
  late List pesanArray = [
    {
      "pesan":
          "Assalamualaikum... **IslamBot** siap menjawab sejumlah pertanyaan terkait Islam mulai Al-Quran, Hadits, Fiqih, Sirah, berbagai keputusan ulama dan sebagainya.\n \nSilahkan ketik pertanyaan sesuai format yang disediakan. Ketik *bantuan* jika perlu panduan cara menggunakan IslamBot.\n \n*IslamBot* dibuat oleh **Pesantren Teknologi Modern Assalaam**",
      "fromUser": false,
      "share": false,
      "time": "1",
      "isSelected": false,
      "isFavourite": false,
      "menu": {
        "jmlItem": 3,
        "actions": [
          {"action": "Acak Ayat"},
          {"action": "Share Acak"},
          {"action": "Bantuan"}
        ],
        "isSpeaking": false,
        "useSpeaker": false
      }
    },
    {
      "pesan":
          "**IslamBot** adalah chatbot berbasis Artificial Intelligence (AI) yang membantu menjawab berbagai pertanyaan terkait Islam mulai Al-Quran, Hadits, Fiqih, Sirah, berbagai keputusan ulama dan sebagainya.\n \nSilahkan kirim chat dengan teks, suara, dan gambar dengan format sebagai berikut\n \n1. Ayat tertentu. Sebutkan nama/nomor surat dan nomor ayat\n     Contoh: **Al-Baqarah:183**\n     Contoh: **Al-Baqarah ayat 183**\n     Contoh: **2:183**\n     Contoh: **2 ayat 183**\n \n2. Ayat sekian sampai sekian. Sebutkan nama/nomor surat dan nomor ayat awal sampai akhir\n     Contoh: **Al-Baqarah:183-185**\n     Contoh: **Al-Baqarah ayat 183-185**\n     Contoh: **Al-Baqarah ayat 183 sampai 185**\n     Contoh: **2:183-185**\n     Contoh: **2 ayat 183-185**\n     Contoh: **2:183 sampai 185**\n     Contoh: **2 ayat 183 sampai 185**\n \n3. Tafsir ayat tertentu\n     Contoh: **Tafsir 2:183**\n     Contoh: **Tafsir Al-Baqarah:183**\n     Contoh: **Tafsir Al-Baqarah ayat 183**\n \n4. Informasi surat. Sebutkan nama/nomor surat\n     Contoh: **Al-Baqarah surat ke berapa?**\n     Contoh: **Surat ke 2 surat apa?**\n     Contoh: **Al-Baqarah**\n     Contoh: **Tentang Al-Baqarah**\n     Contoh: **Tentang surat Al-Baqarah**\n \n5. Ayat secara acak\n     Contoh: **Acak**\n \n6. Share (bagikan) ayat secara acak atau ayat tertentu\n     Contoh: **Share acak**\n     Contoh: **Share Al-Baqarah:183**\n     Contoh: **Share Al-Baqarah ayat 183**\n     Contoh: **Share 2:183**\n     Contoh: **Share 2 ayat 183**\n \n7. Cari teks di terjemah atau teks Arab\n     Contoh: **Cari surga**\n     Contoh: **Cari surga#2**\n \n8. Set terjemahan: Indonesia, Melayu\n     Contoh: **Set terjemahan melayu**\n \n9. Set tafsir: Jalalayn, Kemenag, Muyassar, Ringkas\n     Contoh: **Set tafsir kemenag**\n \n10. Lainnya: Ayat terpendek, ayat terpanjang, surat terpendek, surat terpanjang, surat makiyah, surat madaniyah, surat makiyah dan madaniyah\n\n*IslamBot* dibuat oleh *Pesantren Teknologi Modern Assalaam*",
      "fromUser": false,
      "share": false,
      "time": "2",
      "isFavourite": false,
      "isSelected": false,
      "menu": {
        "jmlItem": 36,
        "actions": [
          {
            "action": "Al-Baqarah:183",
          },
          {
            "action": "Al-Baqarah ayat 183",
          },
          {
            "action": "2:183",
          },
          {
            "action": "2 ayat 183",
          },
          {
            "action": "Al-Baqarah:183-185",
          },
          {
            "action": "Al-Baqarah ayat 183-185",
          },
          {
            "action": "Al-Baqarah ayat 183 sampai 185",
          },
          {
            "action": "2:183-185",
          },
          {
            "action": "2 ayat 183-185",
          },
          {
            "action": "2:183 sampai 185",
          },
          {
            "action": "2 ayat 183 sampai 185",
          },
          {
            "action": "Tafsir 2:183",
          },
          {
            "action": "Tafsir Al-Baqarah:183",
          },
          {
            "action": "Tafsir Al-Baqarah ayat 183",
          },
          {
            "action": "Al-Baqarah surat ke berapa?",
          },
          {
            "action": "Surat ke 2 surat apa?",
          },
          {
            "action": "Al-Baqarah",
          },
          {
            "action": "Tentang Al-Baqarah",
          },
          {
            "action": "Tentang surat Al-Baqarah",
          },
          {
            "action": "Acak",
          },
          {
            "action": "Share Acak",
          },
          {
            "action": "Share Al-Baqarah:183",
          },
          {
            "action": "Share Al-Baqarah ayat 183",
          },
          {
            "action": "Share 2:183",
          },
          {
            "action": "Share 2 ayat 183",
          },
          {
            "action": "cari surga",
          },
          {
            "action": "cari surga#2",
          },
          {
            "action": "Set terjemahan melayu",
          },
          {
            "action": "Set tafsir kemenag",
          },
          {
            "action": "Ayat terpendek",
          },
          {
            "action": "Ayat terpanjang",
          },
          {
            "action": "Surat terpendek",
          },
          {
            "action": "Surat terpanjang",
          },
          {
            "action": "Surat makiyah",
          },
          {
            "action": "Surat madaniyah",
          },
          {
            "action": "Surat makiyah dan madaniyah",
          }
        ],
        "isSpeaking": false,
        "useSpeaker": false
      }
    }
  ];
  List csvData = [];
  late List selectedItems = [];
  List labeledItems = [];
  List labelColors = [
    Color.fromARGB(255, 255, 155, 155),
    Color.fromARGB(255, 255, 217, 155),
    Color.fromARGB(255, 170, 255, 155),
    Color.fromARGB(255, 121, 255, 253),
    Color.fromARGB(255, 155, 158, 255),
    Color.fromARGB(255, 255, 155, 252)
  ];
  bool qbotSpeaking = false;
  bool isFirstRun = true;
  late Map<String, GlobalKey> _itemKeys = {};

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    log('in chat page');
    _autoScrollController = AutoScrollController()
      ..addListener(() {
        setState(() {
          if (_autoScrollController.offset >=
              _autoScrollController.position.minScrollExtent + 20) {
            showUpButton = false;
          } else {
            showUpButton = true;
          }
        });
      });

    getArray('pesanArray', objKey: widget.messageStamp);
    /* for (int i = 0; i < pesanArray.length; i++) {
      _itemKeys[ObjectKey(pesanArray[i]["time"])] = GlobalKey();
    } */
    /* if (widget.messageStamp != null) {
      log('stamp: ${widget.messageStamp}');

      /* final itemKey = ObjectKey(widget.messageStamp);
      final itemContext = _itemKeys[0]?.currentContext;
      if (itemContext != null) {
        listScrollController.animateTo(
          itemContext
              .findRenderObject()!
              .getTransformTo(null)
              .getTranslation()
              .y,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } */
    } */

    AppSettings.loadSettings();
    checkFirstRun();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();
    readLocal();
    super.initState();
  }

  pushPesanArray(
    String pesan,
    Map menu, {
    bool fromUser = true,
    bool isShare = false,
    String suratAyat = "",
    bool isFavourite = false,
  }) async {
    String imgUrl = isShare
        ? "http://15.235.156.254:5111/api/v1/bots/islambot/share/${suratAyat}?&client=islambot&apikey=uxwMtiFW63oPC0QD"
        : "noUrl";
    DateTime waktu = DateTime.now();
    setState(() {
      pesanArray.add({
        "pesan": pesan,
        "fromUser": fromUser,
        "time": waktu.toString(),
        "share": isShare,
        "imgUrl": imgUrl,
        "isFavourite": isFavourite,
        "isSelected": false,
        "menu": menu
      });
    });
    print('--------- 219: pushPesanArray');
  }

  void readLocal() {
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: peerId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            this.widget.arguments.peerNickname,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            selectedItems.length != 0
                ? IconButton(
                    onPressed: () async {
                      String labelName = '';

                      await getLabeledItems();

                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          List<int> labelIndex =
                              []; // label yang dipilih nanti dimasukkan ke sini

                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text('Label Pesan'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 200),
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Column(
                                        children: List.generate(
                                            labeledItems.length, (index) {
                                          String labelName =
                                              labeledItems[index]['labelName'];
                                          bool isChecked = false;
                                          return ListTile(
                                            leading: Icon(
                                              Icons.label,
                                              color: labelColors[
                                                  labeledItems[index]
                                                      ['labelColor']],
                                            ),
                                            minLeadingWidth: 5,
                                            title: Text(labelName),
                                            trailing: SizedBox(
                                              width:
                                                  20, // Lebar yang sesuai dengan kebutuhanmu
                                              child: Checkbox(
                                                // Menggunakan labelIndex untuk menentukan nilai checkbox
                                                value: labelIndex
                                                        .contains(index) &&
                                                    textLabelNameController.text
                                                        .trim()
                                                        .isEmpty,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (!labelIndex
                                                            .contains(index) &&
                                                        textLabelNameController
                                                            .text
                                                            .trim()
                                                            .isEmpty) {
                                                      log('true');
                                                      labelIndex.add(
                                                          index); // Menambahkan indeks label ke dalam labelIndex jika checkbox diaktifkan
                                                    } else {
                                                      log('false');
                                                      labelIndex.remove(
                                                          index); // Menghapus indeks label dari labelIndex jika checkbox dinonaktifkan
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      labelName = value;
                                    },
                                    controller: textLabelNameController,
                                    decoration: InputDecoration(
                                      hintText: '+ Label baru',
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 58, 86, 100),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 58, 86, 100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                    // menambahkan label dengan label baru
                                    if (labelName.trim().isNotEmpty) {
                                      log('klik new label, pesan dipilih: ${selectedItems.length}');
                                      await getLabeledItems();
                                      setState(() {
                                        labeledItems.add({
                                          "labelName": labelName,
                                          "labelColor": labeledItems.length > 5
                                              ? labelColors[sisabagi(
                                                  labeledItems.length, 5)]
                                              : labeledItems.length,
                                          "listPesan": selectedItems
                                        });
                                      });

                                      await saveLabeledItems();
                                      await clearSelectedItems();

                                      log('selecteditems: $selectedItems');
                                      log('sukses melabel pesan: ${labeledItems}');
                                      setState(() {
                                        labeledItems.clear();
                                      });

                                      Fluttertoast.showToast(
                                          msg:
                                              'Disimpan dengan label "$labelName"',
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white);
                                      Navigator.pop(context);
                                    }
                                    // menambahkan label yang tersedia
                                    else if (labelIndex.isNotEmpty) {
                                      await getLabeledItems();

                                      // setiap label yang terpilih
                                      for (var e in labelIndex) {
                                        log('akan dilabel di index: $e');

                                        // setiap item yang terpilih
                                        for (var e2 in selectedItems) {
                                          setState(() {
                                            List listPesan =
                                                labeledItems[e]["listPesan"];

                                            int indexKeberadaan =
                                                listPesan.indexWhere((e3) {
                                              if (e3.containsValue(
                                                  e2['pesanObj'])) {
                                                return true;
                                              } else {
                                                return false;
                                              }
                                            });

                                            // jika pesan belum ditambahkan ke label, maka tambahkan ke label
                                            // jika sudah, tidak perlu
                                            if (indexKeberadaan == -1) {
                                              log('${listPesan.indexOf(e2)}');
                                              listPesan.add(e2);
                                            }
                                            log('menemukan: ${listPesan.indexOf(e2)}');

                                            log('$listPesan');
                                          });
                                        }
                                      }
                                      log('selecteditems: $selectedItems');
                                      log('sukses melabel pesan: ${labeledItems}');

                                      await saveLabeledItems();
                                      await clearSelectedItems();
                                      setState(() {
                                        labeledItems.clear();
                                      });

                                      Fluttertoast.showToast(
                                          msg:
                                              'Disimpan di ${labelIndex.length} label',
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
                          });
                        },
                      );
                    },
                    icon: Icon(
                      Icons.new_label_rounded,
                      color: Colors.white,
                    ))
                : IconButton(
                    onPressed: () {
                      log('START buka label page');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LabelPage()));
                      log('DONE buka label page');
                    },
                    icon: Icon(
                      Icons.label,
                      color: Colors.white,
                    )),
            selectedItems.length == 0
                ? PopupMenuButton(
                    color: Colors.white,
                    onSelected: (value) {
                      print('klik di popup menu, pojok kanan atas');
                      _onMenuItemSelected(value as int);
                    },
                    itemBuilder: (ctx) => [
                          _buildPopupMenuItem('Export Messages',
                              Icons.upload_file_rounded, Options.export.index),
                          _buildPopupMenuItem(
                              'Import Messages',
                              Icons.file_download_rounded,
                              Options.import.index),
                          _buildPopupMenuItem(
                              'Clear Messages',
                              Icons.cleaning_services_rounded,
                              Options.clear.index),
                          _buildPopupMenuItem(
                              'Labels', Icons.label, Options.labels.index),
                          _buildPopupMenuItem('Pengaturan', Icons.settings,
                              Options.settings.index),
                          _buildPopupMenuItem('About IslamBot',
                              Icons.info_outline_rounded, Options.about.index),
                          _buildPopupMenuItem('Exit Application',
                              Icons.exit_to_app_rounded, Options.exit.index),
                        ])
                : IconButton(
                    onPressed: () {
                      clearSelectedItems();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buttonScrollBottom(),
      body: Container(
        // background
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.jpg"),
                repeat: ImageRepeat.repeatY)),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buatListPesan(),

                  // Input content
                  buildInput(),
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
        ),
      ),
    );
  }

  Row buttonScrollBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          height: 30,
          margin: EdgeInsets.fromLTRB(0, 0, 5, 50),
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 2,
              highlightElevation: 2,
              child: Icon(
                showUpButton
                    ? Icons.keyboard_double_arrow_up
                    : Icons.keyboard_double_arrow_down,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: showUpButton ? scrollToTop : scrollToBottom),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          // Button send image
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.landscape
                ? 21
                : 10,
            child: Container(
              height: 50,
              margin:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? EdgeInsets.fromLTRB(10, 5, 5, 7)
                      : EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 1, color: Colors.black26, offset: Offset(0, 2))
              ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1),
                      child: InkWell(
                        onTap: () {
                          openCamera();
                        },
                        child: Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Edit text | inputan teks
                  Expanded(
                    flex: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 11
                        : 5,
                    child: Container(
                      child: TextField(
                        enabled: !listening,
                        readOnly: listening,
                        cursorColor: Colors.teal,
                        style: TextStyle(
                            color: ColorConstants.primaryColor,
                            fontFamily: "IslamBot",
                            fontSize: AppSettings.regularTextSize),
                        controller: textEditingController,
                        onChanged: (text) {
                          if (!listening) {
                            setState(() {
                              text.isEmpty
                                  ? pakaiTeks = false
                                  : pakaiTeks = true;
                            });
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          hintText: loadingOcr
                              ? "Proses scanning..."
                              : "Coba \"Albaqarah 127\"",
                          hintStyle: TextStyle(
                              color: ColorConstants.greyColor,
                              fontFamily: "IslamBot",
                              fontSize: AppSettings.regularTextSize,
                              height: 1.5),
                        ),
                        focusNode: focusNode,
                        autofocus: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Button send message
          Expanded(
              flex: 2,
              child: Container(
                height: 50,
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          color: Colors.black26,
                          offset: Offset(0, 2))
                    ],
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 0, 168, 132)),
                child: IconButton(
                  icon: Icon(
                    pakaiTeks ? Icons.send : Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // ini pakai inputan teks
                    if (pakaiTeks) {
                      // Lakukan logika pengiriman pesan seperti sebelumnya
                      String newTeks = textEditingController.text
                          .replaceAll(RegExp(r'\n+|\s(?!\w)'), '');
                      await pushPesanArray(newTeks, {});
                      textEditingController.clear();
                      // Set ulang pakaiTeks menjadi false
                      setState(() {
                        pakaiTeks = false;
                      });
                      await qbotStop();
                      await saveArray();

                      // listScrollController.jumpTo(
                      //     listScrollController.position.minScrollExtent +
                      //         (pakaiTeks ? 50 : 0));

                      await islamBot('Text', newTeks);

                      // Scroll ke bawah
                      _autoScrollController.animateTo(
                        _autoScrollController.position.minScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }

                    // ini pakai speech-to-text
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(pesanSnackbar(
                          'Mulai mendengarkan...',
                          warna: Colors.teal[600]));
                      setState(() {
                        listening = true;
                      });

                      // Mulai speech-to-text
                      bool isAvailable = await speechToText.initialize();
                      if (isAvailable) {
                        await speechToText.listen(
                          localeId: "id_ID",
                          onResult: (SpeechRecognitionResult result) {
                            // Update TextField dengan hasil speech-to-text secara realtime
                            setState(() {
                              textEditingController.text =
                                  result.recognizedWords;
                            });

                            if (result.finalResult) {
                              setState(() {
                                pakaiTeks = true;
                              });
                            }
                          },
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                            pesanSnackbar('Berhenti mendengarkan',
                                warna: Colors.teal[600]));
                        setState(() {
                          listening = false;
                        });
                      } else {
                        // Jika speech-to-text tidak tersedia, berikan pesan atau tindakan yang sesuai
                        print('Speech-to-text tidak tersedia');
                      }
                    }
                  },
                  color: ColorConstants.primaryColor,
                ),
              )),
        ],
      ),
    );
  }

  SnackBar pesanSnackbar(String pesan,
      {Color? warna = Colors.grey, Color? warnaPesan = Colors.white}) {
    return SnackBar(
      content: Text(
        pesan,
        style: TextStyle(color: warnaPesan),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: warna,
    );
  }

  // buat block pesan
  Widget buatItem(Map pesan, int index, {bool fromUser = true}) {
    // log('index: $index - ${_itemKeys[pesanArray[index]["time"]]}');
    /* final kunciGlobal = ValueKey<String>('${pesanArray[index]["time"]}');
    log('$kunciGlobal'); */
    return InkWell(
      // key: kunciGlobal,
      onLongPress: () async {
        if (pesan['isSelected'] == false && selectedItems.length == 0) {
          await getLabeledItems();
          setState(() {
            selectItem = true;
            pesan['isSelected'] = true;
            selectedItems.add({"inx": index, "pesanObj": pesan['time']});
          });
          log('selectItem[$index] = ${pesan['isSelected']}');
        }
      },
      onTap: () {
        if (pesan['isSelected']) {
          setState(() {
            pesan['isSelected'] = false;
            selectedItems.removeWhere((element) => element["inx"] == index);
          });
          log('selectItem[$index] = ${pesan['isSelected']}');
        } else if (selectedItems.length != 0) {
          setState(() {
            pesan['isSelected'] = true;
            selectedItems.add({"inx": index, "pesanObj": pesan['time']});
          });
          log('selectItem[$index] = ${pesan['isSelected']}');
          log('isi selectedItem: ${selectedItems}');
        }
      },
      child: AutoScrollTag(
        key: ValueKey(index),
        controller: _autoScrollController,
        index: index,
        child: Row(
          mainAxisAlignment:
              fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              foregroundDecoration: BoxDecoration(
                  color: pesan['isSelected']
                      ? Color.fromARGB(50, 0, 168, 132)
                      : Color.fromARGB(0, 0, 168, 132),
                  backgroundBlendMode: BlendMode.darken),
              child: Container(
                // cek apakah pesan dari user?
                child: fromUser
                    // jika pesan dari user
                    ? RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: pesan['pesan'],
                            style: TextStyle(
                              fontFamily: "IslamBot",
                            ),
                          ),
                        ], style: TextStyle(color: Colors.black, fontSize: 17)),
                      )

                    // jika pesan dari bot
                    : Stack(alignment: Alignment.topRight, children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* // tombol favorit
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    print('tekan favorit');
                                    setState(() {
                                      pesan['isFavourite'] =
                                          pesan['isFavourite'] == true
                                              ? false
                                              : true;
                                      saveArray();
                                    });
                                    print('is favorit? ${pesan['isFavourite']}');
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  icon: pesan['isFavourite']
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.favorite_border_rounded,
                                          color: Colors.grey[400],
                                        )),
                            ), */
                            // cek apakah share ayat?
                            pesan['share']
                                ? FullScreenImage(imageUrl: pesan['imgUrl'])
                                : BoldAsteris(text: pesan['pesan']),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 1,
                              color: Colors.black12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: pesan['share']
                                  // button menu untuk pesan share
                                  ? [
                                      Expanded(
                                        flex: 3,
                                        child: listButton(pesan),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 30,
                                        color: Colors.grey[300],
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.share_rounded,
                                                  size: 35,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                  try {
                                                    final url = Uri.parse(
                                                        pesan['imgUrl']);
                                                    final response =
                                                        await http.get(url);
                                                    final bytes =
                                                        response.bodyBytes;

                                                    final temp =
                                                        await getTemporaryDirectory();
                                                    final path =
                                                        '${temp.path}/image.jpg';
                                                    File(path).writeAsBytesSync(
                                                        bytes);

                                                    await Share.shareFiles(
                                                        [path],
                                                        text:
                                                            'Gunakan IslamBot untuk membuat share seperti ini.');
                                                  } catch (e) {
                                                    // handle error
                                                  } finally {
                                                    Navigator.of(context).pop();
                                                  }
                                                }),
                                          )),
                                    ]
                                  // button menu untuk pesan teks
                                  : [
                                      Expanded(
                                          flex: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.landscape
                                              ? 6
                                              : 3,
                                          child: listButton(pesan)),
                                      Container(
                                        width: 1,
                                        height: 30,
                                        color: Colors.grey[300],
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child:
                                              buttonTts(pesan['pesan'], index))
                                    ],
                            )
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          child: IconButton(
                              onPressed: () {
                                print('tekan favorit');
                                setState(() {
                                  pesan['isFavourite'] =
                                      pesan['isFavourite'] == true ? false : true;
                                  saveArray();
                                });
                                print('is favorit? ${pesan['isFavourite']}');
                              },
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: pesan['isFavourite']
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border_rounded,
                                      color: Colors.grey[400],
                                    )),
                        )
                      ]),
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                // ini untuk ngatur max size
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        // (langscape)
                        ? pesan['share']
                            ? 315 // ukuran untuk block share ayat
                            : MediaQuery.of(context).size.width -
                                80 // ukuran block pesan
                        // (potrait)
                        : pesan['share']
                            ? 315 // ukuran block share
                            : MediaQuery.of(context).size.width -
                                80), //ukuran block pesan
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          color: Colors.black26,
                          offset: Offset(0, 2))
                    ],
                    color: fromUser
                        ? Color.fromARGB(255, 231, 255, 219)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                margin: MediaQuery.of(context).orientation ==
                        Orientation.landscape
                    ? EdgeInsets.only(bottom: 5, right: 15, left: 15, top: 5)
                    : EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 5),
              ),
            )
          ],
        ),
      ),
    );
  }

  // button menu
  Widget listButton(Map pesanItem) {
    return InkWell(
      child: Container(
        alignment: Alignment(-1, 0.4),
        height: 40,
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.list,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              TextSpan(
                  text: " Menu IslamBot",
                  style: TextStyle(
                    fontFamily: "IslamBot",
                    fontSize: 17,
                    height: 1.5,
                    color: Colors.blue,
                  )),
            ],
          ),
        ),
      ),

      // DIALOG ISLAMBOT MENU
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(0),
              title: Container(
                  padding: EdgeInsets.all(20),
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color.fromARGB(255, 58, 86, 100),
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menu IslamBot',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ))),
              content: Container(
                width: double.minPositive,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        height: 1,
                        color: Colors.black12,
                      ),
                      InkWell(
                        child: Container(
                            height: 60,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(pesanItem['menu']['actions'][index]
                                    ['action']),
                              ),
                            )),
                        onTap: () async {
                          // buat variabel supaya bisa mendapatkan panjang menu
                          List arr = pesanItem['menu']['actions'];

                          // dapatkan isi pesan
                          // ini digunakan untuk copy dan share
                          String pesanAnswer = pesanItem['pesan'];

                          log('tap menu di index: $index');

                          // arr.length - 3, berarti di index "Copy to Clipboard" (terdapat tombol bantuan)
                          // jika tiada tombol bantuan maka arr.length - 2
                          if (index ==
                              arr.indexWhere((element) =>
                                  element.containsValue('Copy to Clipboard'))) {
                            print('START copy to clipborad');

                            await Clipboard.setData(
                                ClipboardData(text: pesanAnswer));
                            Navigator.of(context).pop(); // close dialog menu

                            print('DONE copy to clipboard');
                          }

                          // arr.length - 2, berarti di index "Share", share teks (terdapat tombol bantuan)
                          // jika tiada tombol bantuan maka arr.length - 1
                          else if (index ==
                              arr.indexWhere((element) =>
                                  element.containsValue('Share'))) {
                            print('START share teks');

                            // munculkan dialog share teks
                            await Share.share(pesanAnswer,
                                subject: pesanAnswer
                                    .split('\n')
                                    .first
                                    .replaceAll(RegExp(r'\*'), ''));
                            Navigator.of(context).pop(); // close dialog menu

                            print('DONE share teks');
                          }

                          //user kirim pesan melalui menu
                          else {
                            await pushPesanArray(
                                pesanItem['menu']['actions'][index]['action'],
                                {});
                            await qbotStop();
                            await saveArray();

                            Navigator.of(context).pop();
                            _autoScrollController.jumpTo(
                                _autoScrollController.position.minScrollExtent);
                            await islamBot('Menu',
                                pesanItem['menu']['actions'][index]['action']);

                            // scroll ke bawah
                            _autoScrollController.animateTo(
                                _autoScrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          }
                        },
                      ),
                    ],
                  ),
                  itemCount: pesanItem['menu']['jmlItem'],
                  reverse: false,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // BUTTON TTS
  Widget buttonTts(String teks, int indexKe) {
    return Container(
      child: Center(
          child: pesanArray[indexKe]['menu']['useSpeaker']
              // tampilan button jika tombol speaker dipencet
              ? Row(children: [
                  // tombol pause dan resume
                  Expanded(
                      child: IconButton(
                    icon: Icon(
                      pesanArray[indexKe]['menu']['isSpeaking']
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 40,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      setState(() {
                        pesanArray[indexKe]['menu']['isSpeaking']
                            ? pesanArray[indexKe]['menu']['isSpeaking'] = false
                            : pesanArray[indexKe]['menu']['isSpeaking'] = true;
                      });
                      pesanArray[indexKe]['menu']['isSpeaking']
                          ? print('speaking')
                          : print('stop steapking');
                      ;
                      if (pesanArray[indexKe]['menu']['isSpeaking']) {
                        await qbotSpeak(teks);
                        setState(() {
                          pesanArray[indexKe]['menu']['isSpeaking'] = false;
                          pesanArray[indexKe]['menu']['useSpeaker'] = false;
                        });
                      } else {
                        qbotPause();
                      }
                    },
                  )),

                  // tombol stop
                  Expanded(
                      child: IconButton(
                    icon: Icon(
                      Icons.stop_rounded,
                      size: 40,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      print('page: tekan stop');
                      await qbotStop();
                      setState(() {
                        speaking = false;
                        pesanArray[indexKe]['menu']['useSpeaker'] = false;
                      });
                    },
                  ))
                ])
              // tampilan button jika tombol speaker belum dipencet
              : Row(
                  children: [
                    Expanded(
                        child: IconButton(
                            onPressed: () async {
                              pesanArray[indexKe]['menu']['useSpeaker']
                                  ? print('off')
                                  : print('on');
                              pesanArray[indexKe]['menu']['isSpeaking'] =
                                  true; // ketika ditekan langsung speaking
                              setState(() {
                                pesanArray[indexKe]['menu']['useSpeaker']
                                    ? pesanArray[indexKe]['menu']
                                        ['useSpeaker'] = false
                                    : pesanArray[indexKe]['menu']
                                        ['useSpeaker'] = true;
                                speaking = true;
                              });

                              // split teks menjadi per paragraf supaya bisa baca teks panjang
                              List paragraphs = teks.split('\n');

                              for (var paragraph in paragraphs) {
                                if (speaking) {
                                  await qbotSpeak(paragraph);
                                }
                              }

                              // await qbotSpeak(
                              //     teks);
                              /* menunggu selesai speaking */
                              // ketika selesai speaking, button kembali ke speaker
                              setState(() {
                                pesanArray[indexKe]['menu']['isSpeaking'] =
                                    false;
                                pesanArray[indexKe]['menu']['useSpeaker'] =
                                    false;
                                speaking = false;
                              });
                            },
                            icon: Icon(
                              Icons.volume_up_rounded,
                              size: 40,
                              color: Colors.grey,
                            )))
                  ],
                )),
    );
  }

  // buat list pesan, berisi item dari fungsi buatItem()
  Widget buatListPesan() {
    return Expanded(
      child: SingleChildScrollView(
        reverse: true,
        controller: _autoScrollController,
        child: Column(
          children: List.generate(
            pesanArray.length,
            (index) {
              // Dismissible untuk drag and delete, hapus pesan
              return Dismissible(
                key: ObjectKey(pesanArray[index]),
                confirmDismiss: (direction) async {
                  await clearSelectedItems();
                  await getLabeledItems(); //panggil item terlabel untuk menghapus juga id di dalamnya
                  // Menampilkan konfirmasi dialog
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Hapus pesan ini?'),
                        content:
                            Text('Pesan yang dihapus tidak bisa dikembalikan.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                  setState(() {
                    // hapus pesan yang di label dulu
                    labeledItems.forEach((item) {
                      final List listPesan = item['listPesan'];
                      listPesan.removeWhere((pesan) =>
                          pesan['pesanObj'] == pesanArray[index]['time']);
                    });

                    // lalu hapus pesan di chatpage
                    pesanArray.removeAt(index);
                  });
                  await saveLabeledItems();
                  saveArray();

                  // kosongkan variabel labeleditems supaya tidak memenuhi RAM
                  setState(() {
                    labeledItems.clear();
                  });
                },
                child: buatItem(pesanArray[index], index,
                    fromUser: pesanArray[index]['fromUser']),
              );
            },
          ),
        ),
      ),
    );
  }

  // save array
  saveArray({bool showLog = true}) async {
    if (showLog) print('START save pesanArray');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // convert List<Map> menjadi String
    String strPesanArray = jsonEncode(pesanArray);

    // save List<String> ke device
    await prefs.setString('pesanArray', strPesanArray);

    if (showLog) print('DONE save pesanArray');
  }

  // clear array
  clearArray() async {
    print('START clear pesanArray');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await qbotStop();

    setState(() {
      pesanArray.removeWhere((element) => !element['isFavourite']);
    });

    await saveArray(showLog: false);

    print('DONE clear pesanArray');
  }

  // read array yang disimpan | get array yang disimpan
  getArray(String kunci, {String objKey = ''}) async {
    print('START get array');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? items = await prefs.getString(kunci);
    // jika items tidak kosong. info: ternyata tanda '?' setelah typeData artinya kemugkinan variable berisi NULL
    if (items != null) {
      List mapList = jsonDecode(items);
      print('------------ get array');
      setState(() {
        pesanArray = mapList;
      });
      saveArray();
    } else {
      print('Nilai untuk kunci $kunci tidak ditemukan');
    }

    // jika objKey tidak kosong
    if (objKey != '') {
      await Future.delayed(const Duration(milliseconds: 100), () {
        var theIndex = pesanArray.indexWhere((e) => e['time'] == objKey);
        /* for (var e in pesanArray) {
          setState(() {
            _itemKeys[e["time"]] = GlobalKey();
          });
        } */
        if (theIndex != -1) {
          scrollToRow(theIndex);
        } else {
          Fluttertoast.showToast(
            msg: 'Pesan tidak ditemukan',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        log('dari get array, objKey: $objKey, theIndex: $theIndex');
      });
      // scrollToItem(objKey);
    }
    // kembalikan stamp jadi null
    setState(() {
      widget.messageStamp = null;
    });
  }

  // cek pertama kali dibuka
  Future<void> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // jika pertama kali dibuka maka autostart TTS pesan pertama
    if (prefs.getBool('isFirstRun') ?? true) {
      setState(() {
        pesanArray[0]['menu']['isSpeaking'] = true;
        pesanArray[0]['menu']['useSpeaker'] = true;
      });
      await qbotSpeak(pesanArray[0]['pesan']);
      setState(() {
        pesanArray[0]['menu']['isSpeaking'] = false;
        pesanArray[0]['menu']['useSpeaker'] = false;
      });
    }
    setState(() {
      isFirstRun = prefs.getBool('isFirstRun') ?? true;
      if (isFirstRun) {
        prefs.setBool('isFirstRun', false);
      }
    });
  }

  // fungsi IslamBot balas pesan
  islamBot(String MenuOrText, String teks) async {
    bool isShare =
        teks.contains(RegExp(r'^(share|bagi(kan|))', caseSensitive: false));
    Map resQBot = await toAPI(teks);
    String jawabQBot = resQBot['answer'];

    // buat variabel list menu dengan kondisi jika null
    List listMenu = resQBot['actions'] == null
        ? [
            {"action": "Acak Ayat"},
            {"action": "Share Acak"},
            {"action": "Bantuan"}
          ]
        : resQBot['actions'];

    // antisipasi jika listMenu tidak memiliki isi
    listMenu.length == 0
        ? listMenu = [
            {"action": "Acak Ayat"},
            {"action": "Share Acak"},
            {"action": "Bantuan"}
          ]
        : // jika memiliki isi, tambah menu Copy dan Share teks
        // jika list terakhir "bantuan" maka di-insert sebelum bantuan, jika bukan maka di-insert di bagian terakhir
        listMenu.insertAll(
            listMenu[listMenu.length - 1]["action"] == "Bantuan"
                ? listMenu.length - 1
                : listMenu.length,
            [
                {"action": "Copy to Clipboard"},
                {"action": "Share"},
              ]);

    await pushPesanArray(
        jawabQBot,
        {
          "jmlItem": listMenu.length,
          "actions": listMenu,
          "isSpeaking": false,
          "useSpeaker": false
        },
        fromUser: false,
        isShare: isShare,
        suratAyat: jawabQBot);
    // jika share ayat, tidak perlu autostart TTS
    isShare
        ? print('SHARE AYAT, tanpa TTS')
        : AppSettings.enableTTS
            // autoTTS on
            ? Future.delayed(Duration(milliseconds: 1500), () async {
                setState(() {
                  pesanArray[pesanArray.length - 1]['menu']["isSpeaking"] =
                      true;
                  pesanArray[pesanArray.length - 1]['menu']["useSpeaker"] =
                      true;
                });
                await qbotSpeak(jawabQBot);
                print('uda speking via $MenuOrText');
                setState(() {
                  pesanArray[pesanArray.length - 1]['menu']["isSpeaking"] =
                      false;
                  pesanArray[pesanArray.length - 1]['menu']["useSpeaker"] =
                      false;
                });
              })
            // autoTTS off
            : print('tanpa auto TTS');
    setState(() {
      pesanArray[pesanArray.length - 1]['menu'] = {
        "jmlItem": listMenu.length,
        "actions": listMenu,
        "isSpeaking": false,
        "useSpeaker": false
      };
      pesanArray.length < 2
          ? print('do nothing')
          : pesanArray[pesanArray.length - 2]['menu']["isSpeaking"] = false;
      pesanArray.length < 2
          ? print('do nothing')
          : pesanArray[pesanArray.length - 2]['menu']["useSpeaker"] = false;
    });
    await saveArray();
  }

  // fungsi scroll to bottom
  scrollToBottom() {
    print('START scroll to bottom');

    if (pesanArray.length > 2) {
      _autoScrollController
          .jumpTo(_autoScrollController.position.minScrollExtent);
    } else {
      print('object ${pesanArray.length}');
    }
    print(
        'DONE scroll to bottom ${_autoScrollController.position.minScrollExtent}');
  }

  // fungsi scroll to bottom
  scrollToTop() {
    print('START scroll to top');

    if (pesanArray.length > 2) {
      _autoScrollController
          .jumpTo(_autoScrollController.position.maxScrollExtent);
    } else {
      print('object ${pesanArray.length}');
    }
    print(
        'DONE scroll to top, ${_autoScrollController.position.minScrollExtent}');
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

    if (value == Options.clear.index) {
      // show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus semua pesan?'),
            content: Text('Pesan yang dihapus tidak bisa dikembalikan.'),
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
                  // clear chat
                  await clearArray();
                  // clear label item
                  setState(() {
                    labeledItems.forEach((item) {
                      item['listPesan'].clear();
                    });
                  });
                  saveLabeledItems();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    // exit app
    else if (value == Options.exit.index) {
      print('START exit app');
      SystemNavigator.pop();
      print('DONE exit app');
    }

    // import chat
    else if (value == Options.import.index) {
      print('START import message');
      await loadCsvData();
    }

    // export chat
    else if (value == Options.export.index) {
      print('START export message');
      var isi = '';

      for (var e in pesanArray) {
        var pesan = '${e["pesan"]}';
        var fromUser = '${e["fromUser"]}';
        var time = '${e["time"]}';
        var share = '${e["share"]}';
        var imgUrl = '${e["imgUrl"]}';
        var isFavourite = '${e["isFavourite"]}';
        var menu = '${e["menu"]}';

        isi = isi +
            '"$pesan";$fromUser;$time;$share;$imgUrl;$isFavourite;$menu\n';
      }
      print(isi);
      var toCSV = 'pesan;fromUser;time;share;imgUrl;isFavourite;menu\n' + isi;
      if (await checkStoragePermission()) await createTextFile(toCSV);
      print('DONE export message');
    }

    // about islambot
    else if (value == Options.about.index) {
      print('START open about us page');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUsScreen()),
      );
      print('DONE open about us page');
    } else if (value == Options.labels.index) {
      log('START buka label page');
      Navigator.push(context, MaterialPageRoute(builder: (_) => LabelPage()));
      log('DONE buka label page');
    }

    // settings
    else if (value == Options.settings.index) {
      print('START open SETTINGS page');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
      print('DONE open SETTINGS page');
    }
  }

  //fungsi sisa bagi
  sisabagi(int a, int b) {
    return a % b;
  }

  // fungsi izin akses memori
  Future<bool> checkStoragePermission() async {
    // Mengecek apakah aplikasi memiliki izin akses ke penyimpanan
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      return true;
    } else {
      // Jika tidak memiliki izin, meminta izin akses ke penyimpanan
      var result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // fungsi export file
  createTextFile(String content) async {
    // Periksa izin penyimpanan
    if (await Permission.storage.request().isGranted) {
      // Dapatkan direktori penyimpanan dokumen aplikasi
      final directory = await getApplicationDocumentsDirectory();

      // Gabungkan nama file dengan path direktori
      DateTime now = DateTime.now();
      String filename = DateFormat('yyyyMMdd').format(now);
      filename = 'Islambot-Messages-$filename';
      final path = '/storage/emulated/0/Documents/IslamBot/$filename.csv';

      // Buat file
      final file = File(path);

      // Jika file sudah ada, hapus file lama
      if (await file.exists()) {
        await file.delete();
      }

      // Tulis konten ke file
      await file.writeAsString(content.replaceAll(RegExp(r'\*\*'), '*'));

      // Tampilkan snackbar dengan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
              'File berhasil diekspor di memori internal/Documents/$filename.csv'),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
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

  // fungsi import file / import pesan
  Future<void> loadCsvData() async {
    final directory = await getTemporaryDirectory();
    directory.delete(recursive: true);

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowCompression: false);

    if (result != null) {
      final input = File(result.files.single.path!).openRead();
      final isi = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter(eol: '\n', textDelimiter: '"'))
          .toList();
      final strIsi = '';
      List objFromCsv = [];
      int index = 0;
      print(isi);
      for (var e in isi[1]) {
        objFromCsv.add(parseTextToObjects(e.toString()));
      }

      for (var pesan in objFromCsv[0]) {
        setState(() {
          pesanArray.add(pesan);
        });
        saveArray(showLog: false);
      }
    } else {
      print('cancel import');
    }
  }

  // fungsi ubah teks ke obj
  List<Map<String, dynamic>> parseTextToObjects(String text) {
    print('START parseTextToObjects');
    List<Map<String, dynamic>> objects = [];
    List<String> lines = text.split('\n');

    for (String line in lines) {
      List<String> values = line.split(';');

      if (values.length == 7) {
        Map<String, dynamic> obj = {
          "pesan": "${values[0].toString()}",
          "fromUser": values[1] == "true",
          "time": "${values[2].toString()}",
          "share": values[3] == "true",
          "imgUrl": "${values[4]}",
          "isFavourite": values[5] == "true",
          "menu": jsonDecode(values[6]
              .replaceAllMapped(
                RegExp(r'(\w+)(:)(?!\d+\})', multiLine: true),
                (match) => '"${match.group(1)}"${match.group(2)}',
              )
              .replaceAllMapped(RegExp(r'{"action":([^,}]+)}'),
                  (match) => '{"action":"${match.group(1)}"}')),
        };
        objects.add(obj);
      }
    }

    print('DONE parseTextToObjects');
    return objects;
  }

  // fungsi buka kamera, ambil gambar dari kamera
  void openCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    // Lakukan sesuatu dengan gambar yang diambil, misalnya tampilkan di ImageView
    if (pickedImage != null) {
      // Gunakan pickedImage.path untuk path file gambar yang diambil
      // Tampilkan gambar di ImageView
      setState(() {
        loadingOcr = true;
      });
      String text = await FlutterTesseractOcr.extractText(pickedImage.path,
          language: 'ind',
          args: {
            "psm": "1",
            "preserve_interword_spaces": "1",
          });
      print('hasil ocr: $text');
      setState(() {
        loadingOcr = false;
        textEditingController.text = text;
      });
    }
  }

  // fungsi save labeledItems
  saveLabeledItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('labeledItems', jsonEncode(labeledItems));
    log('saved labeledItems');
  }

  // fungsi get labeleditems
  getLabeledItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? a = await prefs.getString('labeledItems');
    if (a != null) {
      setState(() {
        labeledItems = jsonDecode(a);
      });
      log('labeledItems ditemukan', name: 'getLabeledItems');
    } else {
      log('labeledItems tidak ditemukan', name: 'getLabeledItems');
    }
  }

  // fungsi clear selectedItems
  clearSelectedItems() {
    for (var e in selectedItems) {
      setState(() {
        pesanArray[e['inx']]['isSelected'] = false;
      });
    }

    setState(() {
      selectedItems.clear();
      selectItem = false;
    });
  }

  // fungsi scroll ke pesan spesifik
  /*  void scrollToItem(String objKey) {
    log('start scroll to item $objKey');
    final itemKey = objKey;
    final gloKey = _itemKeys[itemKey];
    log('itemkey: $itemKey');
    log('_itemsKeys: $_itemKeys');
    log('glokey: $gloKey');
    if (gloKey != null) {
      final itemContext = gloKey.currentContext;
      log('itemcontex: $itemContext');
      if (itemContext != null) {
        listScrollController.jumpTo(itemContext
            .findRenderObject()!
            .getTransformTo(null)
            .getTranslation()
            .y);
        log('posisi item: ${itemContext.findRenderObject()!.getTransformTo(null).getTranslation().y}');
      }
    }
  } */
  void scrollToRow(int index) {
    _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
  }
}

// class photo view
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImageView(imageUrl: imageUrl),
          ),
        );
      },
      child: Image.network(
        imageUrl,
        // LOADING INDIKATOR SHARE AYAT
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Colors.teal[900],
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                loadingBuilder:
                    (BuildContext context, ImageChunkEvent? progress) {
                  return progress == null
                      ? Container()
                      : Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        );
                },
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.5,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(
      {required this.peerId,
      required this.peerAvatar,
      required this.peerNickname});
}
