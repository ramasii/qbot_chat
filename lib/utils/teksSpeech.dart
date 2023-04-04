import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

qbotSpeak(String answer) async {
  print('-------- start TTS');
  await flutterTts.setLanguage('id-ID');
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.3);
  flutterTts.speak(answer.replaceAll(RegExp(r'\*'), ''));
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
