import 'dart:convert';
import 'dart:io';

void main() {
  // Read the JSON file into a string
  final jsonString = File('assets/images.json').readAsStringSync();

  // Parse the JSON string into a list of maps
  final List<dynamic> cards = jsonDecode(jsonString);

  // Define the category mappings
  final categoryMappings = {
    "Food and Drinks": [
      "beverage",
      "condiment",
      "gastronomy",
      "ultra-processed food",
      "meat",
      "fruit",
      "plant-based food",
      "food",
      "processed food",
      "cold meat",
      "vegetable",
      "dessert",
      "egg product",
      "sweets",
      "dried fruit",
      "spices",
      "baking",
      "traditional dish"
    ],
    "Buildings and Infrastructure": ["infrastructure"],
    "People": [
      "group",
      "elderly",
      "teenager",
      "baby",
      "family",
      "adult",
      "indigenouos people"
    ],
    "Transport": [
      "land transport",
      "aerial transport",
      "water transport",
      "mode of transport"
    ],
    "Home and Interior Design": [
      "utensil",
      "trousseau",
      "furniture",
      "electrical appliance",
      "crockery",
      "cutlery",
      "decorative item",
      "cleaning product",
    ],
    "Fashion and Accessories": [
      "clothes",
      "jewelry",
      "footwear",
      "accessories",
      "fashion",
      "sportswear"
    ],
    "Feelings and Sensations": ["taste", "body sensation"],
    "Animals": [
      "arachnid",
      "omnivorous",
      "carnivorous",
      "reptile",
      "mammal",
      "dinosaur",
      "annelid",
      "marine animal",
      "amphibian",
      "fish-animal",
      "invertebrate animal",
      "aquatic animal",
      "vertebrate",
      "animal anatomy",
      "herbivorous",
      "fish"
    ],
    "Plants": [
      "tree",
      "flower",
      "bush",
      "herbaceous plant",
      "plant anatomy",
      "plant",
      "fungus"
    ],
    "Technology": [
      "mass media device",
      "hardware",
      "computing",
      "information technology"
    ],
    "Science": [
      "geology",
      "meteorology",
      "biology",
      "physiology",
      "chemistry",
      "mathematics"
    ],
    "Entertainment and Events": [
      "toy",
      "board game",
      "card game",
      "traditional game",
      "video game",
      "game",
      "olympic games",
      "popular event",
      "event",
      "sport event",
      "social event"
    ],
    "Holidays": ["easter week"],
    "Medicine and Health": [
      "physiotherapy",
      "human anatomy",
      "symptom",
      "health personnel",
      "hygiene product",
      "medical procedure"
    ]
  };
  // Modify the category of each card based on the category mappings
  for (final card in cards) {
    card.remove("id");
    card['subcategory'] = card['category'];
    for (final category in categoryMappings.keys) {
      if (categoryMappings[category]!.contains(card['category'])) {
        card['category'] = category;
      }
    }
  }

  // Write the modified cards to a JSON file
  final File file = File('assets/grouped.json');
  file.writeAsStringSync(json.encode(cards));
}

String getCategory(
    Map<dynamic, dynamic> card, Map<String, List<dynamic>> categoryMappings) {
  // Iterate over each category and check if this card belongs to it
  for (final category in categoryMappings.keys) {
    final cardsInCategory = categoryMappings[category];

    if (cardsInCategory!.contains(card['category'])) {
      return category;
    }
  }

  // If the card does not belong to any category, return 'Uncategorized'
  return 'Uncategorized';
}
