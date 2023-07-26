import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecs/credits.dart';
import 'package:pecs/selected_pecs_page/selected_images_window.dart';
import 'package:pecs/selected_pecs_page/selected_pecs_btns_row.dart';
import 'pecs_list/pecs_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final jsonData = await rootBundle.loadString('assets/grouped.json');
  final parsedJson = json.decode(jsonData) as List;
  runApp(MaterialApp(
    title: 'PECS App',
    home: PecsApp(pecsImages: parsedJson.cast()),
    debugShowCheckedModeBanner: false,
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
  String? _selectedCategory;
  final GlobalKey<PecsSelectorState> pecsSelectorKey =
      GlobalKey<PecsSelectorState>();

  void _handleSelectionChange(List<Map<String, dynamic>> selectedPecs) {
    setState(() {
      _selectedPecs = selectedPecs;
    });
  }

  void _handleCategorySelectionChange(String? selectedCategory) {
    setState(() {
      _selectedCategory = selectedCategory;
    });
  }

  _showSelectedImagesWindow(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectedImagesWindow(
          pecsSelectorKey: pecsSelectorKey,
          selectedPecs: _selectedPecs,
          clearSelectedPecs: () => {_handleSelectionChange([])},
        ),
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
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'credits':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const CreditPage()),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'credits',
                  child: Text('Credits'),
                ),
              ],
            ),
          ],
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
                onCategorySelectionChanged: _handleCategorySelectionChange,
              ),
            ),
            if (_selectedCategory != null)
              SelectedPecsRow(
                selectedPecs: _selectedPecs,
                showSelectedImages: () => _showSelectedImagesWindow(context),
                clearSelectedPecs: () {
                  pecsSelectorKey.currentState!.clearPecs();
                  _handleSelectionChange([]);
                },
              ),
          ],
        ),
      ),
    );
  }
}
