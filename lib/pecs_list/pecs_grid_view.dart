import 'package:flutter/material.dart';

class PecsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> displayedPecs;
  final List<Map<String, dynamic>> selectedPecs;
  final double imageWidth;
  final Function(int index) onTap;

  const PecsGridView({
    Key? key,
    required this.displayedPecs,
    required this.selectedPecs,
    required this.imageWidth,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              onTap(index);
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
                  Image.network(
                    displayedPecs[index]['url']!,
                    width: imageWidth,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
