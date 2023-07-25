import 'package:flutter/material.dart';
import 'package:pecs/funcs/gtranslator.dart';
import 'package:pecs/openai/openai_request.dart';
import 'package:pecs/selected_pecs_page/text_to_speech.dart';

class GPT3SpeechSector extends StatelessWidget {
  final List<Map<String, dynamic>> selectedPecs;

  const GPT3SpeechSector({Key? key, required this.selectedPecs})
      : super(key: key);

  Future<String> _getResult() async {
    final words =
        selectedPecs.map((pecs) => pecs['keyword']!).toList(growable: false);
    final result = await CompletionsApi.getSentence(words.cast());

    final translated = await translate(result);
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getResult(),
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          return const Text("Error occurred!");
        } else if (snapshot.hasData) {
          return Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text('Result: '),
                  Text(
                    snapshot.data!,
                    style: const TextStyle(fontFamily: 'Roboto'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TextToSpeechWidget(text: snapshot.data!),
            ],
          );
        } else {
          return const Center(
            child: SizedBox(
              width: 45,
              height: 45,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
