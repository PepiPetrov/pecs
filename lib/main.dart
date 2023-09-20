import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecs/add_card/add_card.dart';
import 'package:pecs/credits.dart';
import 'package:pecs/firebase_options.dart';
import 'package:pecs/selected_pecs_page/selected_images_window.dart';
import 'package:pecs/selected_pecs_page/selected_pecs_btns_row.dart';
import 'pecs_list/pecs_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final groupedFile = File('${documentsDirectory.path}/grouped.json');
  if (!(await groupedFile.exists())) {
    final jsonData = await rootBundle.loadString('assets/grouped.json');
    groupedFile.writeAsString(jsonData);
  }
  final parsedJson = json.decode(await groupedFile.readAsString()) as List;

  runApp(MaterialApp(
    title: 'PECS App',
    home: PecsApp(
      pecsImages: parsedJson.cast(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class PecsApp extends StatefulWidget {
  final List<Map<String, dynamic>> pecsImages;

  const PecsApp({Key? key, required this.pecsImages})
      : super(key: key);

  @override
  State createState() => _PecsAppState();
}

class _PecsAppState extends State<PecsApp> {
  List<Map<String, dynamic>> _selectedPecs = [];
  String? _selectedCategory;
  final GlobalKey<PecsSelectorState> pecsSelectorKey =
      GlobalKey<PecsSelectorState>();
  List<Map<String, dynamic>> pecsImages = [];

  @override
  void initState() {
    pecsImages = widget.pecsImages;
    super.initState();
  }

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
                  case 'add_picture':
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddRecordPage(
                                pecsImages: pecsImages.cast(),
                              )),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'credits',
                  child: Text('Лиценз'),
                ),
                const PopupMenuItem<String>(
                    value: 'add_picture', child: Text("Добави карта")),
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
                pecsImages: pecsImages,
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
