import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PecsSelector extends StatefulWidget {
  final List<Map<String, String>> pecsImages;
  final Function(List<Map<String, String>> selectedPecs) onSelectionChanged;
  final int numImagesPerRow;

  const PecsSelector({
    Key? key,
    required this.pecsImages,
    required this.onSelectionChanged,
    this.numImagesPerRow = 3,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PecsSelectorState createState() => _PecsSelectorState();
}

class _PecsSelectorState extends State<PecsSelector> {
  final List<Map<String, String>> _selectedPecs = [];

  _toggleSelected(int index) {
    setState(() {
      if (_selectedPecs.contains(widget.pecsImages[index])) {
        _selectedPecs.remove(widget.pecsImages[index]);
      } else {
        _selectedPecs.add(widget.pecsImages[index]);
      }
    });
    widget.onSelectionChanged(_selectedPecs);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = (screenWidth - (widget.numImagesPerRow - 1) * 8) /
        widget.numImagesPerRow;
    final imageHeight = imageWidth;

    return GridView.builder(
      itemCount: widget.pecsImages.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.numImagesPerRow,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: imageWidth / imageHeight,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _toggleSelected(index);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedPecs.contains(widget.pecsImages[index])
                    ? Colors.blue
                    : Colors.grey,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CachedNetworkImage(
                    imageUrl: widget.pecsImages[index]["image"]!,
                    width: imageWidth,
                    height: imageHeight,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
