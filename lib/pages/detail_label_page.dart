import 'dart:developer';

import 'package:IslamBot/utils/allpackages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../qbotterminal.dart';
import '../utils/bold.dart';
import 'pages.dart';

class DetailLabel extends StatefulWidget {
  final Map labelData;

  DetailLabel({required this.labelData});

  @override
  _DetailLabelState createState() => _DetailLabelState();
}

class _DetailLabelState extends State<DetailLabel> {
  @override
  void initState() {
    super.initState();
    log('in detail label page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            '${widget.labelData['labelName']}',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop()),
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
                            DateTime timeA =
                                DateTime.parse(a['pesanObj']['time']);
                            DateTime timeB =
                                DateTime.parse(b['pesanObj']['time']);
                            return timeA.compareTo(timeB);
                          });

                          Map pesanObj = sortedPesan[index2]['pesanObj'];

                          return InkWell(
                            onTap: () {
                              log('tap pesan index  ke-$index2, time: ${pesanObj["time"]}');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    messageStamp: pesanObj["time"],
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
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: pesanInLabel(pesanObj: pesanObj),
                                      ),
                                      Divider(
                                        indent: 20,
                                        endIndent: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )));
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
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${pesanObj['fromUser'] ? 'Anda' : 'IslamBot'}: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: pesanObj['pesan'].replaceAll(RegExp(r'\*'), ''),
          ),
        ],
      ),
      maxLines: 6,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
