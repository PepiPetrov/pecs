// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pecs/pecs_button.dart';

class SelectedImagesWindow extends StatefulWidget {
  final List<Map<String, String>> selectedPecs;
  final int numImagesPerRow;

  const SelectedImagesWindow({
    Key? key,
    required this.selectedPecs,
    this.numImagesPerRow = 6,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SelectedImagesWindowState createState() => _SelectedImagesWindowState();
}

class _SelectedImagesWindowState extends State<SelectedImagesWindow> {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final imageWidth = screenWidth / widget.numImagesPerRow;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Images'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: widget.numImagesPerRow,
        childAspectRatio: 1.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        // children: widget.selectedPecs
        //     .map(
              // (pecs) => CachedNetworkImage(
              //   imageUrl: pecs['image']!,
              //   width: imageWidth,
              //   fit: BoxFit.cover,
              //   placeholder: (context, url) =>
              //       const CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              // ),
        //     )
        //     .toList(),
        children: [PecsButton(selectedPecs: widget.selectedPecs)],
      ),
    );
  }
}
