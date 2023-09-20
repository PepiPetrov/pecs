import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecs/add_card/image_picker.dart';
import 'package:pecs/main.dart';

class AddRecordPage extends StatefulWidget {
  final List<Map<String, dynamic>> pecsImages;

  const AddRecordPage({Key? key, required this.pecsImages}) : super(key: key);

  @override
  State createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  late TextEditingController recordController;
  late TextEditingController categoryController;
  late String selectedCategory;
  late List<String> categories;

  late File groupedFile;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    recordController = TextEditingController();
    categoryController = TextEditingController();
    categories = [
      ...widget.pecsImages.map((pecs) => pecs['category']).toSet().toList(),
      'Нова категория',
    ];
    selectedCategory = categories.first;
    initializePaths();
  }

  void initializePaths() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    groupedFile = File('${documentsDirectory.path}/grouped.json');
  }

  void getImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  Future<List<Map<String, dynamic>>> _readRecords() async {
    final content = await groupedFile.readAsString();
    return (json.decode(content) as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _addRecord(
      String record, String category) async {
    final records = await _readRecords();

    final someMap = {"keyword": record, "category": category, "url": imageUrl};

    records.add(someMap);

    await groupedFile.writeAsString(json.encode(records));
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добави нова карта'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: recordController,
              decoration: const InputDecoration(labelText: 'Дума'),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue ?? "";
                });

                if (newValue == "Нова категория") {
                  _showCreateCategoryDialog();
                }
              },
            ),
            const SizedBox(height: 16.0),
            ImageUploads(setImgUrl: getImageUrl),
            ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> records = await _readRecords();
                try {
                  final record = recordController.text;
                  final category = selectedCategory;
                  records = await _addRecord(record, category);
                } finally {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PecsApp(
                            pecsImages: records,
                          )));
                }
              },
              child: const Text('Добави карта'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void _showCreateCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Създаване на нова категория'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Име на категория'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Назад'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Създай'),
              onPressed: () {
                final newCategory = categoryController.text;
                if (newCategory.isNotEmpty) {
                  setState(() {
                    categories.insert(categories.length - 1, newCategory);
                    selectedCategory = newCategory;
                    categoryController.clear();
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    recordController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}
