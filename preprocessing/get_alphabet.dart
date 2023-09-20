import 'dart:convert';
import 'dart:io';

void main() {
  // Read the JSON file into a string
  final jsonString = File('../assets/grouped.json').readAsStringSync();

  // Parse the JSON string into a list of maps
  final List<dynamic> cards = jsonDecode(jsonString);
  final List<dynamic> catsAndWord = [];
  // Modify the category of each card based on the category mappings
  for (final card in cards) {
    if (card["categories"].contains("alphabet")) {
      catsAndWord.add(card);
    }
  }

  final File file = File('alphabet.json');
  file.writeAsStringSync(json.encode(cards));
}
