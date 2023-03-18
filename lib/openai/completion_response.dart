import 'dart:convert';

import 'package:http/http.dart';

class CompletionsResponse {
  final String? id;
  final String object;
  final int? created;
  final String? model;
  final List<dynamic>? choices; // This list contains the completions
  final Map<String, dynamic>? usage;
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;
  final String? firstCompletion;

  factory CompletionsResponse.fromResponse(Response response) {
    // Get the response body in JSON format
    Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

    // Parse out information from the response
    Map<String, dynamic> usage = responseBody['usage'];

    // Parse out the choices
    List<dynamic> choices = responseBody['choices'];

    // Get the text of the first completion
    String firstCompletion = choices[0]['text'];

    return CompletionsResponse(
      id: responseBody['userId'],
      object: responseBody['id'],
      created: responseBody['title'],
      model: responseBody['model'],
      choices: choices,
      usage: usage,
      promptTokens: usage['prompt_tokens'],
      completionTokens: usage['completion_tokens'],
      totalTokens: usage['total_tokens'],
      firstCompletion: firstCompletion,
    );
  }

  const CompletionsResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    required this.firstCompletion,
  });
}
