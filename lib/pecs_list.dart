import 'package:flutter/material.dart';

class PecsSelector extends StatefulWidget {
  final List<Map<String, dynamic>> pecsImages;
  final Function(List<Map<String, dynamic>> selectedPecs) onSelectionChanged;
  final int numImagesPerRow;

  const PecsSelector({
    Key? key,
    required this.pecsImages,
    required this.onSelectionChanged,
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
    if (selectedCategory == null) {
      return widget.pecsImages;
    } else {
      return widget.pecsImages
          .where((pecs) => pecs['category'] == selectedCategory)
          .toList();
    }
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = (screenWidth - (widget.numImagesPerRow - 1) * 8) /
        widget.numImagesPerRow;

    return Column(
      children: [
        selectedCategory == null
            ? Wrap(
                spacing: 4.0,
                children: [
                  for (String category in categories)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Text(
                        category,
                      ),
                    ),
                ],
              )
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
                  setState(() {
                    selectedCategory = null;
                  });
                },
                child: const Text('Back'),
              ),
            ],
          ),
        if (selectedCategory != null)
          Expanded(
            child: GridView.builder(
              itemCount: displayedPecs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _toggleSelected(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedPecs.contains(displayedPecs[index])
                            ? Colors.blue
                            : Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Image.network(
                            displayedPecs[index]['url']!,
                            width: imageWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
