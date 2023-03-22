import 'package:flutter/material.dart';
import 'package:pecs/openai/completion_response.dart';
import 'package:pecs/openai/openai_request.dart';
import 'package:pecs/text_to_speech.dart';

class GPT3Button extends StatefulWidget {
  final List<Map<String, String>> selectedPecs;

  const GPT3Button({Key? key, required this.selectedPecs}) : super(key: key);

  @override
  State createState() => _GPT3ButtonState();
}

class _GPT3ButtonState extends State<GPT3Button> {
  late String resultText = "No result\n\n";

  Future<void> _handleGPT3Request() async {
    List<String> words =
        widget.selectedPecs.map((pec) => pec['word']!).toList();
    CompletionsResponse result = await CompletionsApi.getSentence(words);

    int startIndex =
        result.firstCompletion!.indexOf("Bulgarian") + "Bulgarian".length;

    String bulgarianText = result.firstCompletion!.substring(startIndex);
    setState(() {
      resultText = bulgarianText.replaceAll(":", "").trim();
      resultText += "\n\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _handleGPT3Request(),
          child: const Text('Request GPT-3'),
        ),
        // const SizedBox(height: 10),
        const SelectableText("Result: "),
        SelectableText(
          resultText,
          style: const TextStyle(fontFamily: "Roboto"),
        ),
        const SizedBox(height: 30),
        // const SelectableText(
        //   "Selected words: ",
        //   style: TextStyle(fontFamily: "Roboto"),
        // ),
        // Column(
        //   children: widget.selectedPecs
        //       .map((pecs) => SelectableText(
        //             pecs["word"]!,
        //             style: const TextStyle(fontFamily: "Roboto"),
        //           ))
        //       .toList(),
        // ),
        !resultText.contains("No result")
            ? TextToSpeechWidget(text: resultText)
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ],
    );
  }
}
