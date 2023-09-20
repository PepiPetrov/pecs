import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final List<Map<String, dynamic>> images;
  final double imageWidth;
  final Function(String? selectedCategory) onCategorySelectionChanged;

  const CategoryList(
      {Key? key,
      required this.categories,
      required this.images,
      required this.onCategorySelectionChanged,
      required this.imageWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final imgs = images.where((e) => e["category"] == category).toList();
          // final String imgUrl = imgs[(imgs.length <= 2 ? 0 : 2)]["url"]!;
          late String imgUrl = imgs[0]["url"]!;
          switch (category) {
            case "Сгради и инфраструктура":
              imgUrl = imgs[31]["url"];
              break;
            case "Навън":
              imgUrl = imgs[5]["url"];
              break;
            case "Технологии":
              imgUrl = imgs[10]["url"];
              break;
            case "Музика":
            case "Образование":
            case "Медицина":
              imgUrl = imgs[1]["url"];
              break;
            case "Свободно време":
              imgUrl = imgs
                  .where((element) => element["keyword"] == "chess board")
                  .toList()[0]["url"]!;
              break;
            case "Свят":
              imgUrl = imgs
                  .where((element) => element["keyword"] == "mayor")
                  .toList()[0]["url"]!;
              break;
            case "Наука":
              imgUrl = imgs
                  .where((element) => element["keyword"] == "DNA")
                  .toList()[0]["url"]!;
              break;
            default:
          }

          return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  onCategorySelectionChanged(category);
                },
                child: Column(children: [
                  Image.network(
                    imgUrl,
                    width: imageWidth - 30.667,
                    height: 100,
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ));
        },
      ),
    );
  }
}
