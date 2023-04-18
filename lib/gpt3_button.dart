import 'package:flutter/material.dart';
import 'package:pecs/gtranslator.dart';
import 'package:pecs/openai/openai_request.dart';
import 'package:pecs/text_to_speech.dart';

class GPT3SpeechSector extends StatefulWidget {
  final List<Map<String, dynamic>> selectedPecs;

  const GPT3SpeechSector({Key? key, required this.selectedPecs})
      : super(key: key);

  @override
  State createState() => _GPT3SpeechSectorState();
}

class _GPT3SpeechSectorState extends State<GPT3SpeechSector> {
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

    final translated = await translate(result);
    setState(() {
      resultText = translated;
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
