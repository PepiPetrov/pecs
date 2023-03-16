import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';
import 'package:pecs/env.dart';

class PecsButton extends StatefulWidget {
  final List<Map<String, String>> selectedPecs;

  const PecsButton({Key? key, required this.selectedPecs}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PecsButtonState createState() => _PecsButtonState();
}

class _PecsButtonState extends State<PecsButton> {
  late String choice = "";

  Future<void> _handlePecsTap() async {
    List<String> words =
        widget.selectedPecs.map((pec) => pec['word']!).toList();
    String englishSentence = words.join(' ');
    String requestText =
        'Construct a sentence in Bulgarian using the following words from PECS cards. First, construct the sentence in English and then translate it: $englishSentence';

    const conf = OpenAIConfiguration(apiKey: openaiApiKey);

    final client = OpenAIClient(configuration: conf);

    final completion = await client.completions
        .create(
            model: 'text-davinci-003',
            prompt: requestText,
            maxTokens: 200,
            n: 1,
            stop: '\n')
        .data;

    setState(() {
      choice = completion.choices[0].text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth / 3;
    return GestureDetector(
      onTap: () => _handlePecsTap(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: widget.selectedPecs
                  .map((pec) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: CachedNetworkImage(
                          imageUrl: pec['image']!,
                          width: imageWidth,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ))
                  .toList(),
            ),
            Text(choice),
          ],
        ),
      ),
    );
  }
}
