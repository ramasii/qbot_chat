import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> fetchData(inputUser) {
  return http.get(Uri.parse('http://15.235.156.254:5111/api/v1/bots/qbotflutter/input?input=$inputUser&client=islambot&apikey=uxwMtiFW63oPC0QD'));
}

toAPI(inputUser) async {
  print('----------------------- fetching to API');
  var response = await fetchData(inputUser);
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    print('---------- QBOT: $jsonResponse');
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.statusCode;
  }
}

tipsPLaceholder(){
  var tips = ['Coba "garputala"','Coba "ayat acak"','Coba "cari surga"','Coba "cari surga:2"','Coba "Al-ma\'un:1"','Coba "tafsir Al-fatihah:1"','Coba "An-naba\' ayat 1"','Coba "bantuan"'];
  var index = Random().nextInt(tips.length);
  return tips[index];
}