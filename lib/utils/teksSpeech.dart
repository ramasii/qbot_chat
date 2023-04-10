import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

qbotSpeak(String answer) async {
  print('-------- start TTS');
  // await flutterTts.setLanguage('id-ID');
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.3);
  await flutterTts.setVoice({"name": "id-id-x-idd-local", "locale": "id-ID"});

  //replace beberapa kata supaya enak dibaca TTS
  String speakThis = answer
      .replaceAll(RegExp(r'\*'), '')
      .replaceAll(RegExp(r'QS.'), ' Qur\'an surat ')
      .replaceAll(RegExp(r'(?<!-)\[(?=\d)'), '[ayat ')
      .replaceAll(RegExp(r'(?<=\])-(?=\[)'), ' sampai ');
  flutterTts.speak(speakThis);
}

Future<dynamic> qbotStop() async {
  print('tekan stop');
  await flutterTts.stop();
}

Future<dynamic> qbotPause() async {
  print('tekan pause');
  await flutterTts.pause();
}

Future<dynamic> qbotComplete() async {
  await flutterTts.awaitSpeakCompletion(true);
}
