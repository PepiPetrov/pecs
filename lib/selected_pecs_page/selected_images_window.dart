import 'package:flutter/material.dart';
import 'package:pecs/selected_pecs_page/gpt3_button.dart';
import 'package:pecs/pecs_list/pecs_list.dart';

class SelectedImagesWindow extends StatefulWidget {
  final List<Map<String, dynamic>> selectedPecs;
  final int numImagesPerRow;
  final GlobalKey<PecsSelectorState> pecsSelectorKey;
  final Function() clearSelectedPecs;

  const SelectedImagesWindow(
      {Key? key,
      required this.selectedPecs,
      this.numImagesPerRow = 6,
      required this.pecsSelectorKey,
      required this.clearSelectedPecs})
      : super(key: key);

  @override
  State createState() => _SelectedImagesWindowState();
}

class _SelectedImagesWindowState extends State<SelectedImagesWindow> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth / widget.numImagesPerRow;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избрани Изображения'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ...widget.selectedPecs.map(
                      (pecs) => Image.network(
                        pecs['url']!,
                        width: imageWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(children: [
                GPT3SpeechSector(selectedPecs: widget.selectedPecs),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.pecsSelectorKey.currentState?.clearPecs();
                    widget.clearSelectedPecs();
                    Navigator.pop(context);
                  },
                  child: const Text('Назад'),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
