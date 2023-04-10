import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show post;
import 'package:pecs/openai/openai_request.dart';
import 'package:pecs/text_to_speech.dart';

class GPT3Button extends StatefulWidget {
  final List<Map<String, dynamic>> selectedPecs;

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

  Future<void> _getResultAndAddToState() async {
    final words = widget.selectedPecs.map((pecs) => pecs['keyword']!).toList();
    final result = await CompletionsApi.getSentence(words);

    Uri uri = Uri.https('translate.googleapis.com', '/translate_a/single',
        {'client': 'gtx', 'sl': 'en', 'tl': 'bg', 'dt': 't', 'q': result});
    final response = await post(uri);
    final decodedBody = jsonDecode(response.body);
    setState(() {
      resultText = decodedBody[0][0][0];
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
        resultText.contains('No result')
            ? const SizedBox()
            : TextToSpeechWidget(text: resultText)
      ],
    );
  }
}
