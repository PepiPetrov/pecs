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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Display three items per row
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      primary: false,
      padding: const EdgeInsets.all(4.0),
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        final category = categories[index];
        return SizedBox(
          child: ElevatedButton(
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
                fontSize: 14.0, // Decrease the font size
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
