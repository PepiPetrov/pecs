import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pecs/selected_images_window.dart';
import 'pecs_list.dart';

Future<String> _loadJsonAsset() async {
  return await rootBundle.loadString('assets/images.json');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final jsonData = await _loadJsonAsset();
  final parsedJson = json.decode(jsonData) as List<dynamic>;
  runApp(MaterialApp(
    title: 'PECS App',
    home: PecsApp(pecsImages: parsedJson.cast()),
  ));
}

class PecsApp extends StatefulWidget {
  final List<Map<String, dynamic>> pecsImages;

  const PecsApp({Key? key, required this.pecsImages}) : super(key: key);

  @override
  State createState() => _PecsAppState();
}

class _PecsAppState extends State<PecsApp> {
  List<Map<String, dynamic>> _selectedPecs = [];
  final GlobalKey<PecsSelectorState> pecsSelectorKey =
      GlobalKey<PecsSelectorState>();

  void _handleSelectionChange(List<Map<String, dynamic>> selectedPecs) {
    setState(() {
      _selectedPecs = selectedPecs;
    });
  }

  _showSelectedImagesWindow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectedImagesWindow(
            pecsSelectorKey: pecsSelectorKey, selectedPecs: _selectedPecs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PECS',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PECS'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            Expanded(
              child: PecsSelector(
                key: pecsSelectorKey,
                pecsImages: widget.pecsImages,
                onSelectionChanged: _handleSelectionChange,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        _showSelectedImagesWindow(context);
                      },
                      child: const Text('Show selected PECS'),
                    );
                  },
                ),
                const SizedBox(
                  width: 80,
                ),
                ElevatedButton(
                  onPressed: () {
                    pecsSelectorKey.currentState?.clearPecs();
                  },
                  child: const Text('Clear selected PECS'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
