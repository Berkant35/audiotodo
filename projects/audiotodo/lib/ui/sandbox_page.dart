import 'package:audiotodo/core/theme/custom_colors.dart';
import 'package:audiotodo/main.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../generated/l10n.dart';
import '../utilities/components/buttons/mini_button.dart';
import '../utilities/components/buttons/neu_text_button.dart';
import '../utilities/components/buttons/play_stop_button.dart';
import '../utilities/components/logo/glow_logo.dart';

class SandBoxPage extends ConsumerStatefulWidget {
  const SandBoxPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SandBoxPageState();
}

class _SandBoxPageState extends ConsumerState<SandBoxPage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  final openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      isLog: true);

  //

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void sendRequest(String meetingText) async {

   logger.i("Meeting text:$meetingText");
   Dio dio = Dio();
    String url = 'https://simple-chatgpt-api.p.rapidapi.com/ask';
    Map<String, String> headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': '6d96d2f4f4msh41e94f792ad1f8ap1d93a8jsn23461e0f8b83',
      'X-RapidAPI-Host': 'simple-chatgpt-api.p.rapidapi.com'
    };
    String data =
        '{"question":" [$meetingText] köşeli parantez içerisinde bir toplantıda geçen bir konuşma var bu konuşmadaki kişilerin todo listesini json formatta hazırlayabilir misin? Eğer kayda değer bir todo list oluşmuyorsa null dön"}';

    debugPrint("Data: $data")    ;
    try {
      Response response = await dio.post(
        url,
        options: Options(headers: headers),
        data: data,
      );
      print(response.data);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.meeting),
      ),
      backgroundColor: CustomColors.primaryColor,
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.grey.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const GlowLogo(),
            SizedBox(
              height: 8.h,
            ),
            //PlayStopButton(onPressed: _startListening),
            ElevatedButton(
                onPressed: () => sendRequest(_lastWords),
                child: const Text("get"))
          ],
        ),
      ),
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
        onResult: (event) => _onSpeechResult(event), localeId: 'tr_TR');
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.alternates.first.recognizedWords;
      logger.i("New Result: $_lastWords");
    });
  }
}
