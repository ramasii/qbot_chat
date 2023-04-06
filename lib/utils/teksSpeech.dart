import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

qbotSpeak(String answer) async {
  print('-------- start TTS');
  await flutterTts.setLanguage('id-ID');
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.3);

  //replace beberapa kata supaya enak dibaca TTS
  String speakThis = answer
      .replaceAll(RegExp(r'\*'), '')
      .replaceAll(RegExp(r'(?<=\d):(?=\d)'), ' ayat ')
      .replaceAll(RegExp(r' (?=\d+\sayat\s\d+)'), ' surat ke ')
      .replaceAll(RegExp(r'QS.'), ' Qur\'an surat ')
      .replaceAll(RegExp(r' (?=\d+\sayat\s\d+)'), ' ayat ')
      .replaceAll(RegExp(r'(?<!-)\[(?=\d)'), '[ayat ')
      .replaceAll(RegExp(r'(?<=\])-(?=\[)'), ' sampai ');

  flutterTts.speak(speakThis);
}

Future<dynamic> qbotStop() async {
  await flutterTts.stop();
}

Future<dynamic> qbotPause() async {
  await flutterTts.pause();
}

Future<dynamic> qbotComplete() async {
  await flutterTts.awaitSpeakCompletion(true);
}
