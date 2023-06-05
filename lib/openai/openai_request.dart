import 'package:http/http.dart';
import 'package:pecs/env.dart';
import 'completion_request.dart';
import 'completion_response.dart';

class CompletionsApi {
  static final Uri completionsEndpoint =
      Uri.parse('https://api.openai.com/v1/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $openAIApiKey',
  };

  static Future<String> getSentence(List<dynamic> words) async {
    String joinedWords = words.join(', ');
    String prompt =
        'Construct a sentence using the following words. Here are the words: $joinedWords\n';

    CompletionsRequest request = CompletionsRequest(
      model: 'text-davinci-003',
      prompt: prompt,
      maxTokens: 256,
      temperature: 0,
      topP: 1,
    );

    Response response = await post(completionsEndpoint,
        headers: headers, body: request.toJson());

    CompletionsResponse completionsResponse =
        CompletionsResponse.fromResponse(response);

    return completionsResponse.firstCompletion!.replaceAll("\"", "");
  }
}
