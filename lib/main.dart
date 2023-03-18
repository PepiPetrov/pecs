import 'package:flutter/material.dart';
import 'package:pecs/selected_images_window.dart';
import 'pecs_list.dart';
import 'urls.dart';

void main() {
  runApp(const MediaQuery(
    data: MediaQueryData(devicePixelRatio: 1),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>> _selectedPecs = [];

  void _handleSelectionChange(List<Map<String, String>> selectedPecs) {
    setState(() {
      _selectedPecs = selectedPecs;
    });
  }

  _showSelectedImagesWindow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectedImagesWindow(
          selectedPecs: _selectedPecs,
          numImagesPerRow: getColumns(context),
        ),
      ),
    );
  }

  int getColumns(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width >= 992) {
      // Desktop or laptop
      return 7;
    } else if (screenSize.width >= 768) {
      // Tablet
      return 4;
    } else {
      // Mobile
      return 3;
    }
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
                  numImagesPerRow: getColumns(context)),
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
