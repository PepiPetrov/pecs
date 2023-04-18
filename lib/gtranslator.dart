import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' show post;

Future<String> translate(String text) async {
  Uri uri = Uri.https('translate.googleapis.com', '/translate_a/single',
      {'client': 'gtx', 'sl': 'en', 'tl': 'bg', 'dt': 't', 'q': text});
  final response = await post(uri);
  final decodedBody = jsonDecode(response.body);
  return decodedBody[0][0][0];
}
