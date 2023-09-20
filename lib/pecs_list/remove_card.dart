import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecs/main.dart';

class RemoveCard extends StatefulWidget {
  final Map<String, dynamic> image;
  final List<Map<String, dynamic>> images;

  const RemoveCard({
    Key? key,
    required this.image,
    required this.images,
  }) : super(key: key);

  @override
  State createState() => _RemoveCardState();
}

class _RemoveCardState extends State<RemoveCard> {
  late File groupedFile;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    initializePaths();
  }

  void initializePaths() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    groupedFile = File('${documentsDirectory.path}/grouped.json');
  }

  void getImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  Future<List<Map<String, dynamic>>> _removeRecord(
      Map<String, dynamic> record) async {
    final content = await groupedFile.readAsString();
    final records = List<Map<String, dynamic>>.from(
      (json.decode(content) as List).cast<Map<String, dynamic>>(),
    );
    records
        .removeAt(records.indexWhere((e) => e["keyword"] == record["keyword"]));
    await groupedFile.writeAsString(json.encode(records));
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          'Изтрий',
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final newRecords = await _removeRecord(widget.image);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PecsApp(
                              pecsImages: newRecords,
                            )));
                  },
                  child: const Text('Да'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Не'),
                ),
              ],
            ),
          ),
        ]);
  }
}
