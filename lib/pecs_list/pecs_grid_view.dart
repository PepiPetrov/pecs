import 'package:flutter/material.dart';
import 'package:pecs/pecs_list/remove_card.dart';

class PecsGridView extends StatefulWidget {
  final List<Map<String, dynamic>> displayedPecs;
  final List<Map<String, dynamic>> selectedPecs;
  final List<Map<String, dynamic>> allPecs;
  final double imageWidth;
  final Function(int index) onTap;

  const PecsGridView(
      {Key? key,
      required this.displayedPecs,
      required this.selectedPecs,
      required this.imageWidth,
      required this.onTap,
      required this.allPecs})
      : super(key: key);

  @override
  State createState() => _PecsGridViewState();
}

class _PecsGridViewState extends State<PecsGridView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: widget.displayedPecs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _showImageOptionsDialog(context, index);
            },
            onTap: () {
              widget.onTap(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      widget.selectedPecs.contains(widget.displayedPecs[index])
                          ? Colors.blue
                          : Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.displayedPecs[index]['url']!,
                    width: widget.imageWidth,
                    height: widget.imageWidth - 4,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageOptionsDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RemoveCard(
            image: widget.displayedPecs[index],
            images: widget.allPecs,
          );
        });
  }
}
