import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pecs/openai/openai_request.dart';
import 'package:pecs/text_to_speech.dart';

class GPT3Button extends StatefulWidget {
  final List<Map<String, String>> selectedPecs;

  const GPT3Button({Key? key, required this.selectedPecs}) : super(key: key);

  @override
  State createState() => _GPT3ButtonState();
}

class _GPT3ButtonState extends State<GPT3Button> {
  late String resultText;

  @override
  void initState() {
    super.initState();
    resultText = 'No result\n\n';
    _getResultAndAddToState();
  }

  Future<List<String>> _getTranslatedWords() async {
    final words = widget.selectedPecs.map((pecs) => pecs['word']!).toList();
    List<String> translatedWords = [];

    List<Future> futures = words.map((word) async {
      Uri uri = Uri.https('translate.googleapis.com', '/translate_a/single',
          {'client': 'gtx', 'sl': 'en', 'tl': 'bg', 'dt': 't', 'q': word});
      final response = await post(uri);
      final decodedBody = jsonDecode(response.body);
      translatedWords.add(decodedBody[0][0][0]);
    }).toList();

    await Future.wait(futures);

    return translatedWords;
  }

  Future<void> _getResultAndAddToState() async {
    final words = await _getTranslatedWords();
    final result = await CompletionsApi.getSentence(words);
    setState(() {
      resultText = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectableText('Result: '),
        !resultText.contains('No result')
            ? SelectableText(
                resultText,
                style: const TextStyle(fontFamily: 'Roboto'),
              )
            : const Center(
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(),
                ),
              ),
        const SizedBox(height: 10),
        if (!resultText.contains('No result'))
          TextToSpeechWidget(text: resultText)
        else
          const SizedBox(
            height: 0,
            width: 0,
          ),
      ],
    );
  }
}
