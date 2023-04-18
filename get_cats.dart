import 'dart:convert';
import 'dart:io';

void main() {
  // Read the JSON file into a string
  final jsonString = File('assets/images.json').readAsStringSync();

  // Parse the JSON string into a list of maps
  final List<dynamic> cards = jsonDecode(jsonString);
  final Set<String> catsAndWord = {};
  // Modify the category of each card based on the category mappings
  for (final card in cards) {
    catsAndWord.add(card["category"]);
  }

  print(catsAndWord.toList().join("\n"));
}
