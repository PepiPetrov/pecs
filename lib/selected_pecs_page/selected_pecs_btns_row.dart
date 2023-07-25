import 'package:flutter/material.dart';

class SelectedPecsRow extends StatelessWidget {
  final List<Map<String, dynamic>> selectedPecs;
  final VoidCallback showSelectedImages;
  final VoidCallback clearSelectedPecs;

  const SelectedPecsRow({
    Key? key,
    required this.selectedPecs,
    required this.showSelectedImages,
    required this.clearSelectedPecs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: selectedPecs.isNotEmpty ? showSelectedImages : null,
              child: const Text('Show selected PECS'),
            );
          },
        ),
        const SizedBox(
          width: 80,
        ),
        ElevatedButton(
          onPressed: selectedPecs.isNotEmpty ? clearSelectedPecs : null,
          child: const Text('Clear selected PECS'),
        )
      ],
    );
  }
}
