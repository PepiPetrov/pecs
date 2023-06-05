import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final Function(String? selectedCategory) onCategorySelectionChanged;

  const CategoryList({
    Key? key,
    required this.categories,
    required this.onCategorySelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      alignment: WrapAlignment.center,
      children: [
        for (String category in categories)
          ElevatedButton(
            onPressed: () {
              onCategorySelectionChanged(category);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
