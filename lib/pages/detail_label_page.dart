import 'package:IslamBot/utils/allpackages.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 58, 86, 100),
        title: Text(
          widget.labelData['labelName'],
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg.jpg"), fit: BoxFit.cover)),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                widget.labelData['listPesan'].length,
                (index2) {
                  List sortedPesan = List.from(widget.labelData['listPesan']);
                  sortedPesan.sort((a, b) {
                    DateTime timeA = DateTime.parse(a['pesanObj']['time']);
                    DateTime timeB = DateTime.parse(b['pesanObj']['time']);
                    return timeA.compareTo(timeB);
                  });

                  Map pesanObj = sortedPesan[index2]['pesanObj'];

                  return Row(
                    mainAxisAlignment: pesanObj['fromUser']
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(100, 0, 0, 0),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft:
                                Radius.circular(pesanObj['fromUser'] ? 8 : 0),
                            bottomRight:
                                Radius.circular(pesanObj['fromUser'] ? 0 : 8),
                          ),
                          color: pesanObj['fromUser']
                              ? Color.fromARGB(255, 231, 255, 219)
                              : Colors.white,
                        ),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        margin: EdgeInsets.only(
                            top: 2, bottom: 2, left: 5, right: 5),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? MediaQuery.of(context).size.width - 135
                              : MediaQuery.of(context).size.width - 70,
                        ),
                        child: BoldAsteris(text: pesanObj['pesan']),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  
  }
}
