import 'dart:io';
import 'dart:convert';

void main() async {
  // Open the file for reading
  File file = File('output-no-dups.json');
  Stream<List<int>> inputStream = file.openRead();

  // Create a buffer to store the data
  var buffer = StringBuffer();

  // Read the data into the buffer
  await for (var data in inputStream) {
    buffer.write(utf8.decode(data));
  }

  try {
    // Parse the JSON data
    var jsonData = jsonDecode(buffer.toString());

    // Extract categories from pictograms and store in a Set to eliminate duplicates
    var categories = <String>{};
    print(jsonData.length);
    for (var pictogram in jsonData) {
      if (pictogram.containsKey('category')) {
        categories.add(pictogram["category"]);
      }
    }

    // Print the number of unique categories
    print('Total number of unique categories: ${categories.length}');
  } catch (e) {
    print('Error parsing JSON data: $e');
  }
}
