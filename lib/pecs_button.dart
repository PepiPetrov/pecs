import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';
import 'package:pecs/env.dart';

class GPT3Button extends StatefulWidget {
  final List<Map<String, String>> selectedPecs;

  const GPT3Button({Key? key, required this.selectedPecs}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GPT3ButtonState createState() => _GPT3ButtonState();
}

class _GPT3ButtonState extends State<GPT3Button> {
  late String resultText = "";

  Future<void> _handleGPT3Request() async {
    List<String> words =
        widget.selectedPecs.map((pec) => pec['word']!).toList();
    String englishSentence = words.join(', ');
    String requestText =
        'Construct a sentence in Bulgarian using the following words from PECS cards. First, construct the sentence in English and then translate it: $englishSentence';

    const conf = OpenAIConfiguration(apiKey: openAIApiKey);

    final client = OpenAIClient(configuration: conf);

    final completion = await client.completions
        .create(
            model: 'text-davinci-003',
            prompt: requestText,
            maxTokens: 200,
            stop: '\n')
        .data;

    setState(() {
      resultText = completion.choices[0].text;
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
        const SizedBox(height: 10),
        Text(resultText),
      ],
    );
  }
}
