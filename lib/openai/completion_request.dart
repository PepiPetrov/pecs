import 'dart:convert';

class CompletionsRequest {
  final String model;
  final String prompt;
  final int maxTokens;
  final double? temperature;
  final int? topP;
  final int? n;
  final bool? stream;
  final int? longprobs;
  final String? stop;

  String toJson() {
    Map<String, dynamic> jsonBody = {
      'model': model,
      'prompt': prompt,
      'max_tokens': maxTokens,
    };

    if (temperature != null) {
      jsonBody.addAll({'temperature': temperature});
    }

    if (topP != null) {
      jsonBody.addAll({'top_p': topP});
    }

    if (n != null) {
      jsonBody.addAll({'n': n});
    }

    if (stream != null) {
      jsonBody.addAll({'stream': stream});
    }

    if (longprobs != null) {
      jsonBody.addAll({'longprobs': longprobs});
    }

    if (stop != null) {
      jsonBody.addAll({'stop': stop});
    }

    return json.encode(jsonBody);
  }

  CompletionsRequest({
    required this.model,
    required this.prompt,
    required this.maxTokens,
    required this.temperature,
    this.topP,
    this.n,
    this.stream,
    this.longprobs,
    this.stop,
  });
}
