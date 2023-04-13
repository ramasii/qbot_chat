import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// masukkan packages lewat allpackages.dart
import '../utils/allpackages.dart';
import 'pages.dart';
import '../qbotterminal.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.arguments}) : super(key: key);

  final ChatPageArguments arguments;

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

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  late List menuArray = [
    {
      "jmlItem": 3,
      "actions": [
        {"action": "Acak Ayat"},
        {"action": "Share Acak"},
        {"action": "Bantuan"}
      ],
      "isSpeaking": false,
      "useSpeaker": false
    },
    {
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
  ];
  late List pesanArray = [
    {
      "pesan":
          "Assalamualaikum... **IslamBot** siap menjawab sejumlah pertanyaan terkait Islam mulai Al-Quran, Hadits, Fiqih, Sirah, berbagai keputusan ulama dan sebagainya.\n \nSilahkan ketik pertanyaan sesuai format yang disediakan. Ketik *bantuan* jika perlu panduan cara menggunakan IslamBot.\n \n*IslamBot* dibuat oleh **Pesantren Teknologi Modern Assalaam**",
      "fromUser": false,
      "share": false,
      "urut": 0,
      "time": ""
    },
    {
      "pesan":
          "**IslamBot** adalah chatbot berbasis Artificial Intelligence (AI) yang membantu menjawab berbagai pertanyaan terkait Islam mulai Al-Quran, Hadits, Fiqih, Sirah, berbagai keputusan ulama dan sebagainya.\n \nSilahkan kirim chat dengan teks, suara, dan gambar dengan format sebagai berikut\n \n1. Ayat tertentu. Sebutkan nama/nomor surat dan nomor ayat\n     Contoh: **Al-Baqarah:183**\n     Contoh: **Al-Baqarah ayat 183**\n     Contoh: **2:183**\n     Contoh: **2 ayat 183**\n \n2. Ayat sekian sampai sekian. Sebutkan nama/nomor surat dan nomor ayat awal sampai akhir\n     Contoh: **Al-Baqarah:183-185**\n     Contoh: **Al-Baqarah ayat 183-185**\n     Contoh: **Al-Baqarah ayat 183 sampai 185**\n     Contoh: **2:183-185**\n     Contoh: **2 ayat 183-185**\n     Contoh: **2:183 sampai 185**\n     Contoh: **2 ayat 183 sampai 185**\n \n3. Tafsir ayat tertentu\n     Contoh: **Tafsir 2:183**\n     Contoh: **Tafsir Al-Baqarah:183**\n     Contoh: **Tafsir Al-Baqarah ayat 183**\n \n4. Informasi surat. Sebutkan nama/nomor surat\n     Contoh: **Al-Baqarah surat ke berapa?**\n     Contoh: **Surat ke 2 surat apa?**\n     Contoh: **Al-Baqarah**\n     Contoh: **Tentang Al-Baqarah**\n     Contoh: **Tentang surat Al-Baqarah**\n \n5. Ayat secara acak\n     Contoh: **Acak**\n \n6. Share (bagikan) ayat secara acak atau ayat tertentu\n     Contoh: **Share acak**\n     Contoh: **Share Al-Baqarah:183**\n     Contoh: **Share Al-Baqarah ayat 183**\n     Contoh: **Share 2:183**\n     Contoh: **Share 2 ayat 183**\n \n7. Cari teks di terjemah atau teks Arab\n     Contoh: **Cari surga**\n     Contoh: **Cari surga#2**\n \n8. Set terjemahan: Indonesia, Melayu\n     Contoh: **Set terjemahan melayu**\n \n9. Set tafsir: Jalalayn, Kemenag, Muyassar, Ringkas\n     Contoh: **Set tafsir kemenag**\n \n10. Lainnya: Ayat terpendek, ayat terpanjang, surat terpendek, surat terpanjang, surat makiyah, surat madaniyah, surat makiyah dan madaniyah\n\n*IslamBot* dibuat oleh *Pesantren Teknologi Modern Assalaam*",
      "fromUser": false,
      "share": false,
      "urut": 1,
      "time": ""
    }
  ];
  late int urutJawabBot;
  late bool qbotSpeaking;

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    urutJawabBot = 2;
    qbotSpeaking = false;
    menuArray;
    pesanArray;
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    readLocal();
  }

  pushPesanArray(String pesan,
      {bool fromUser = true,
      bool isShare = false,
      String suratAyat = ""}) async {
    String imgUrl = isShare
        ? "http://15.235.156.254:5111/api/v1/bots/islambot/share/${suratAyat}?&client=islambot&apikey=uxwMtiFW63oPC0QD"
        : "";
    DateTime waktu = DateTime.now();
    int urut = fromUser ? 0 : menuArray.length;
    setState(() {
      pesanArray.add({
        "pesan": pesan,
        "fromUser": fromUser,
        "urut": urut,
        "time": waktu,
        "share": isShare,
        "imgUrl": imgUrl
      });
    });
    print('---------- pushPesanArray');
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

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.arguments.peerId);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  void onKirimPesan(
    String content,
    int type,
  ) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.arguments.peerId);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            this.widget.arguments.peerNickname,
            style: TextStyle(color: Colors.white),
          )),
      body: Container(
        // background
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.jpg"), fit: BoxFit.cover)),
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
            flex: 10,
            child: Container(
              height: 50,
              margin: EdgeInsets.all(5),
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
                      child: IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                        onPressed: getImage,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ),

                  // Edit text | inputan teks
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: TextField(
                        cursorColor: Colors.teal,
                        style: TextStyle(
                            color: ColorConstants.primaryColor,
                            fontFamily: "IslamBot",
                            fontSize: 18),
                        controller: textEditingController,
                        onChanged: (text) {
                          setState(() {
                            text.isEmpty ? pakaiTeks = false : pakaiTeks = true;
                          });
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: tipsPLaceholder(),
                          hintStyle: TextStyle(
                              color: ColorConstants.greyColor,
                              fontFamily: "IslamBot",
                              fontSize: 18),
                        ),
                        focusNode: focusNode,
                        autofocus: true,
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
                    String newTeks = textEditingController.text
                        .replaceAll(RegExp(r'\n+|\s(?!\w)'), '');

                    // user kirim pesan
                    pakaiTeks
                        ? await pushPesanArray(newTeks)
                        : print('teks kosong');
                    textEditingController.clear();
                    await qbotStop();

                    // IslamBot balas pesan
                    qbot() async {
                      bool isShare = newTeks.contains(
                          RegExp(r'^(share|bagi(kan|))', caseSensitive: false));
                      Map resQBot = await toAPI(newTeks);
                      String jawabQBot = resQBot['answer'];
                      List listMenu = resQBot['actions'] == null
                          ? [
                              {"action": "Acak Ayat"},
                              {"action": "Share Acak"},
                              {"action": "Bantuan"}
                            ]
                          : resQBot['actions'];
                      await pushPesanArray(jawabQBot,
                          fromUser: false,
                          isShare: isShare,
                          suratAyat: jawabQBot);
                      isShare
                          ? print('SHARE AYAT, tanpa TTS')
                          : Future.delayed(Duration(milliseconds: 1500),
                              () async {
                              setState(() {
                                menuArray[menuArray.length - 1]["isSpeaking"] =
                                    true;
                                menuArray[menuArray.length - 1]["useSpeaker"] =
                                    true;
                              });
                              await qbotSpeak(jawabQBot);
                              print('uda speking via KIRIM TEKS');
                              setState(() {
                                menuArray[menuArray.length - 1]["isSpeaking"] =
                                    false;
                                menuArray[menuArray.length - 1]["useSpeaker"] =
                                    false;
                              });
                            });
                      setState(() {
                        menuArray.add({
                          "jmlItem": listMenu.length,
                          "actions": listMenu,
                          "isSpeaking": false,
                          "useSpeaker": false
                        });
                        menuArray[menuArray.length - 2]["isSpeaking"] = false;
                        menuArray[menuArray.length - 2]["useSpeaker"] = false;
                      });
                    }

                    ;

                    listScrollController.jumpTo(
                        listScrollController.position.maxScrollExtent + 50);
                    if (pakaiTeks) await qbot();

                    // scroll ke bawah
                    listScrollController.animateTo(
                        listScrollController.position.maxScrollExtent + 600,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);

                    setState(() {
                      pakaiTeks = false;
                    });
                  },
                  color: ColorConstants.primaryColor,
                ),
              )),
        ],
      ),
    );
  }

  Widget buatItem(Map pesan, {bool fromUser = true}) {
    return Row(
      mainAxisAlignment:
          fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: fromUser
              ? BoldAsteris(text: pesan['pesan'])
              : Column(
                  children: [
                    // cek apakah share ayat?
                    pesan['share']
                        ? InkWell(
                            child: Image.network(
                              pesan['imgUrl'],
                              // LOADING INDIKATOR SHARE AYAT
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.teal[900],
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),

                            // INI SHARE GAMBAR KE APP LAIN
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (_) => Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                              try {
                                final url = Uri.parse(pesan['imgUrl']);
                                final response = await http.get(url);
                                final bytes = response.bodyBytes;

                                final temp = await getTemporaryDirectory();
                                final path = '${temp.path}/image.jpg';
                                File(path).writeAsBytesSync(bytes);

                                await Share.shareFiles([path],
                                    text:
                                        'Gunakan IslamBot untuk membuat share seperti ini.');
                              } catch (e) {
                                // handle error
                              } finally {
                                Navigator.of(context).pop();
                              }
                            },
                          )
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
                              Center(
                                child: listButton(pesan['urut']),
                              )
                            ]
                          // button menu untuk pesan teks
                          : [
                              Expanded(
                                  flex: 3, child: listButton(pesan['urut'])),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                  flex: 2,
                                  child:
                                      buttonTts(pesan['pesan'], pesan['urut']))
                            ],
                    )
                  ],
                ),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          constraints: BoxConstraints(maxWidth: 315),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 1, color: Colors.black26, offset: Offset(0, 2))
              ],
              color:
                  fromUser ? Color.fromARGB(255, 231, 255, 219) : Colors.white,
              borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 5),
        )
      ],
    );
  }

  // button menu
  Widget listButton(int urut) {
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
                    fontSize: 17,
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
                                child: Text(menuArray[urut]['actions'][index]
                                    ['action']),
                              ),
                            )),
                        onTap: () async {
                          //user kirim pesan
                          await pushPesanArray(
                              menuArray[urut]['actions'][index]['action']);
                          await qbotStop();

                          // IslamBot balas pesan
                          qbot() async {
                            bool isShare = menuArray[urut]['actions'][index]
                                    ['action']
                                .contains(RegExp(r'^(share|bagi(kan|))',
                                    caseSensitive: false));
                            Map resQBot = await toAPI(
                                menuArray[urut]['actions'][index]['action']);
                            String jawabQBot = resQBot['answer'];
                            List listMenu = resQBot['actions'];
                            await pushPesanArray(jawabQBot,
                                fromUser: false,
                                isShare: isShare,
                                suratAyat: jawabQBot);
                            isShare
                                ? print('SHARE AYAT, tanpa TTS')
                                : Future.delayed(Duration(milliseconds: 1500),
                                    () async {
                                    setState(() {
                                      menuArray[menuArray.length - 1]
                                          ["isSpeaking"] = true;
                                      menuArray[menuArray.length - 1]
                                          ["useSpeaker"] = true;
                                    });
                                    await qbotSpeak(jawabQBot);
                                    print('uda speking via MENU BUTTON');
                                    setState(() {
                                      menuArray[menuArray.length - 1]
                                          ["isSpeaking"] = false;
                                      menuArray[menuArray.length - 1]
                                          ["useSpeaker"] = false;
                                    });
                                  });
                            setState(() {
                              menuArray.add({
                                "jmlItem": listMenu.length,
                                "actions": listMenu,
                                "isSpeaking": false,
                                "useSpeaker": false
                              });
                              menuArray[menuArray.length - 2]["isSpeaking"] =
                                  false;
                              menuArray[menuArray.length - 2]["useSpeaker"] =
                                  false;
                            });
                          }

                          Navigator.of(context).pop();
                          listScrollController.jumpTo(
                              listScrollController.position.maxScrollExtent +
                                  50);
                          await qbot();

                          // scroll ke bawah
                          listScrollController.animateTo(
                              listScrollController.position.maxScrollExtent +
                                  600,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                      ),
                    ],
                  ),
                  itemCount: menuArray[urut]['jmlItem'],
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
  Widget buttonTts(String teks, int urut) {
    return Container(
      child: Center(
          child: menuArray[urut]['useSpeaker']
              ? Row(children: [
                  Expanded(
                      // tombol pause dan resume
                      child: IconButton(
                    icon: Icon(
                      menuArray[urut]['isSpeaking']
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 40,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        menuArray[urut]['isSpeaking']
                            ? menuArray[urut]['isSpeaking'] = false
                            : menuArray[urut]['isSpeaking'] = true;
                      });
                      menuArray[urut]['isSpeaking']
                          ? print('speaking')
                          : print('stop steapking');
                      ;
                      menuArray[urut]['isSpeaking']
                          ? qbotSpeak(teks)
                          : qbotPause();
                    },
                  )),
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
                        menuArray[urut]['useSpeaker'] = false;
                      });
                    },
                  ))
                ])
              : Row(
                  children: [
                    Expanded(
                        child: IconButton(
                            onPressed: () async {
                              menuArray[urut]['useSpeaker']
                                  ? print('off')
                                  : print('on');
                              menuArray[urut]['isSpeaking'] =
                                  true; // ketika ditekan langsung speaking
                              setState(() {
                                menuArray[urut]['useSpeaker']
                                    ? menuArray[urut]['useSpeaker'] = false
                                    : menuArray[urut]['useSpeaker'] = true;
                              });
                              await qbotSpeak(
                                  teks); // menunggu selesai speaking
                              setState(() {
                                menuArray[urut]['isSpeaking'] =
                                    false; // ketika selesai speaking, button kembali ke play
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
    return Flexible(
      child: ListView.builder(
        controller: listScrollController,
        itemBuilder: (context, index) => buatItem(pesanArray[index],
            fromUser: pesanArray[index]['fromUser']),
        itemCount: pesanArray.length,
        reverse: false,
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
