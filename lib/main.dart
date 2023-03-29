import 'package:flutter/material.dart';
import 'package:pecs/selected_images_window.dart';
import 'pecs_list.dart';
import 'urls.dart';

void main() {
  runApp(const MaterialApp(
    title: 'PECS App',
    home: PecsApp(),
  ));
}

class PecsApp extends StatefulWidget {
  const PecsApp({super.key});

  @override
  State createState() => _PecsAppState();
}

class _PecsAppState extends State<PecsApp> {
  List<Map<String, String>> _selectedPecs = [];

  void _handleSelectionChange(List<Map<String, String>> selectedPecs) {
    setState(() {
      _selectedPecs = selectedPecs;
    });
  }

  _showSelectedImagesWindow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectedImagesWindow(selectedPecs: _selectedPecs),
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
                pecsImages: pecsImages,
                onSelectionChanged: _handleSelectionChange,
              ),
            ),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              _showSelectedImagesWindow(context)),
                    );
                  },
                  child: const Text('Show selected PECS'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
