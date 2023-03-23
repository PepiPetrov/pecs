import 'package:flutter/material.dart';
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

  Future<void> _getResultAndAddToState() async {
    final words = widget.selectedPecs.map((pecs) => pecs['word']!).toList();
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
