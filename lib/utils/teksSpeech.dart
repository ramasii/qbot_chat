import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

Future qbotSpeak(String answer) async {
  print('-------- start TTS');

  // setting suara
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.3);
  await flutterTts.setVoice({"name": "id-id-x-idd-local", "locale": "id-ID"});

  // replace beberapa kata supaya enak dibaca TTS
  String speakThis = answer
      .replaceAll(RegExp(r'\*|∞'), '')
      .replaceAll(RegExp(r'QS.'), ' Qur\'an surat ')
      .replaceAll(RegExp(r'(?<!-)\[(?=\d)'), '[ayat ')
      .replaceAll(RegExp(r'(?<=\])-(?=\[)'), ' sampai ');
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.speak(speakThis);
}

Future qbotCompleteHandler() async {
  // set handler ketika selesai
  flutterTts.setCompletionHandler(() {});
}

Future<dynamic> qbotStop() async {
  print('qbot stop');
  await flutterTts.stop();
}

Future<dynamic> qbotPause() async {
  print('tekan pause');
  await flutterTts.pause();
  flutterTts.setContinueHandler(() {
    print('resume');
  });
}
