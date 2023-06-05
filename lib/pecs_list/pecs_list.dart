import 'package:flutter/material.dart';
import 'package:pecs/pecs_list/category_list.dart';
import 'package:pecs/pecs_list/pecs_grid_view.dart';

class PecsSelector extends StatefulWidget {
  final List<Map<String, dynamic>> pecsImages;
  final Function(List<Map<String, dynamic>> selectedPecs) onSelectionChanged;
  final Function(String? selectedCategory) onCategorySelectionChanged;
  final int numImagesPerRow;

  const PecsSelector({
    Key? key,
    required this.pecsImages,
    required this.onSelectionChanged,
    required this.onCategorySelectionChanged,
    this.numImagesPerRow = 3,
  }) : super(key: key);

  @override
  State<PecsSelector> createState() => PecsSelectorState();
}

class PecsSelectorState extends State<PecsSelector> {
  List<Map<String, dynamic>> selectedPecs = [];
  String? selectedCategory;

  List<String> get categories {
    // Get a list of unique categories from the pecsImages list
    return widget.pecsImages
        .map((pecs) => pecs['category'])
        .toSet()
        .toList()
        .cast();
  }

  List<Map<String, dynamic>> get displayedPecs {
    // Filter the pecsImages list to only include images with the selected category
    return widget.pecsImages
        .where((pecs) => pecs['category'] == selectedCategory)
        .toList();
  }

  void _toggleSelected(int index) {
    setState(() {
      if (selectedPecs.contains(displayedPecs[index])) {
        selectedPecs.remove(displayedPecs[index]);
      } else {
        selectedPecs.add(displayedPecs[index]);
      }
    });
    widget.onSelectionChanged(selectedPecs);
  }

  void clearPecs() {
    setState(() {
      selectedPecs = [];
    });
  }

  _onCategorySelectionChanged(String? category) {
    setState(() {
      selectedCategory = category;
    });
    widget.onCategorySelectionChanged(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = (screenWidth - (widget.numImagesPerRow - 1) * 8) /
        widget.numImagesPerRow;

    return Column(
      children: [
        selectedCategory == null
            ? CategoryList(
                categories: categories,
                onCategorySelectionChanged: _onCategorySelectionChanged)
            : Wrap(
                spacing: 8.0,
                children: [
                  ElevatedButton(
                    onPressed: null,
                    child: Text(selectedCategory!),
                  ),
                ],
              ),
        if (selectedCategory != null)
          Wrap(
            spacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {
                  _onCategorySelectionChanged(null);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        if (selectedCategory != null)
          PecsGridView(
            displayedPecs: displayedPecs,
            selectedPecs: selectedPecs,
            imageWidth: imageWidth,
            onTap: _toggleSelected,
          ),
      ],
    );
  }
}
