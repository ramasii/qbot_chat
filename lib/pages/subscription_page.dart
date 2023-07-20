import 'dart:developer';
import '../utils/allpackages.dart';
import 'package:flutter/material.dart';
import 'pages.dart';

class SubscriptionScreen extends StatefulWidget {
  bool checkSubs;

  SubscriptionScreen({this.checkSubs = false});

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool isStatusLoading = false;
  bool alreadyMembership = false;

  @override
  void initState() {
    super.initState();
    if (!widget.checkSubs) isMembership();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 58, 86, 100),
          title: Text(
            'Berlangganan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    log('klik premium', name: 'subscriptionPage');
                    setState(() {
                      isStatusLoading = true;
                    });
                    await updateMemberStatus('Premium'); // update member status
                    setState(() {
                      isStatusLoading = false;
                    });
                    log('DONE start premium', name: 'subscriptionPage');
                  },
                  child: ProductCard(Colors.yellow, 'PREMIUM', 'Rp99.000/bulan',
                      '+ Qur\'an\n+ Hadist\n+ Fitur Lengkap\n+ Tanpa Iklan\n+ 1 Bulan',
                      judulSize: 25),
                )),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      log('klik trial', name: 'subscriptionPage');
                      setState(() {
                        isStatusLoading = true;
                      });
                      await updateMemberStatus('Trial');
                      setState(() {
                        isStatusLoading = false;
                      });
                      log('DONE start trial', name: 'subscriptionPage');
                    },
                    child: ProductCard(
                        Color.fromARGB(255, 118, 234, 122),
                        'TRIAL',
                        'Rp0/Minggu',
                        '+ Qur\'an Chat\n+ Fitur Lengkap\n+ Tanpa Iklan\n- 1 Minggu',
                        judulSize: 25),
                  ),
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
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
                      },
                      child: ProductCard(
                          Color.fromARGB(255, 209, 209, 209),
                          'FREE',
                          'Rp0/Lifetime',
                          '+ Qur\'an chat\n+ Lifetime\n- Iklan\n- Fitur Terbatas',
                          judulSize: 25)),
                )
              ],
            ),
          ),
        ));
  }

  Card ProductCard(Color warna, String judul, String subjudul, String deskripsi,
      {double judulSize = 50}) {
    Color cardShade = Color.fromARGB(
        warna.alpha, warna.red - 35, warna.green - 35, warna.blue - 35);

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      // color: warna,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [warna, warna, cardShade],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            judul,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: judulSize,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        subjudul,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: Text(deskripsi)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isStatusLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ]),
    );
  }

  // fungsi
  Future getAllValuesFromUserDocument() async {
    setState(() {
      isStatusLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = await prefs.getString('id');
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid!).get();

      if (documentSnapshot.exists) {
        // log('ketemu', name: 'getAllValuesFromUserDocument()');
        setState(() {
          isStatusLoading = false;
        });
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        // Dokumen tidak ditemukan
        setState(() {
          isStatusLoading = false;
        });
        return null;
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengambil nilai dari dokumen: $e');
      setState(() {
        isStatusLoading = false;
      });
      return null;
    }
  }

  isMembership() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = await prefs.getString('id');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersCollection = firestore.collection('users');
    var a = await getAllValuesFromUserDocument();
    await prefs.setBool('isPremium', a["isPremium"]);
    await prefs.setBool('isTrial', a["isTrial"]);

    if (a["isPremium"] || a["isTrial"]) {
      int p = a["PremiumEnd"] == null ? 0 : int.parse(a["PremiumEnd"]);
      int t = a["TrialEnd"] == null ? 0 : int.parse(a["TrialEnd"]);

      await prefs.setString(
          'PremiumEnd', a["PremiumEnd"] == null ? '0' : a["PremiumEnd"]);
      await prefs.setString(
          'TrialEnd', a["TrialEnd"] == null ? '0' : a["TrialEnd"]);

      if (p > DateTime.now().millisecondsSinceEpoch ||
          t > DateTime.now().millisecondsSinceEpoch) {
        setState(() {
          alreadyMembership = true;
        });
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
      } else {
        await usersCollection.doc(uid!).update({
          'isPremium': false,
          'isTrial': false,
        });
        setState(() {
          alreadyMembership = false;
        });
      }
    } else {
      setState(() {
        alreadyMembership = false;
      });
    }
  }

  Future<void> updateMemberStatus(String jenis) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = await prefs.getString('id');
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference usersCollection = firestore.collection('users');

      var trialStart = DateTime.now().millisecondsSinceEpoch;
      var trialEnd = DateTime.fromMillisecondsSinceEpoch(trialStart)
          .add(Duration(days: jenis == 'Premium' ? 30 : 7))
          .millisecondsSinceEpoch;

      // cek apakah sudah premium atau trial
      Map userDoc = await getAllValuesFromUserDocument();
      if (userDoc["isPremium"] == false && userDoc["isTrial"] == false) {
        // Update the document with the new values
        await usersCollection.doc(uid!).update({
          'is${jenis}': true,
          '${jenis}Start': trialStart.toString(),
          '${jenis}End': trialEnd.toString(),
        });

        print('Member status updated successfully!');
      } else {
        print('Member sudah Premium / Trial');
      }
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
    } catch (e) {
      print('Error updating Member status: $e');
    }
  }
}
