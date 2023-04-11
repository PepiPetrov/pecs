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

  void _toggleSelected(int index) {
    setState(() {
      if (selectedPecs.contains(widget.pecsImages[index])) {
        selectedPecs.remove(widget.pecsImages[index]);
      } else {
        selectedPecs.add(widget.pecsImages[index]);
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

    return GridView.builder(
      itemCount: widget.pecsImages.length,
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
                color: selectedPecs.contains(widget.pecsImages[index])
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
                  widget.pecsImages[index]["url"]!,
                  width: imageWidth,
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
