import 'dart:convert';

import 'package:artisan_ai/Screens/first_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// api key
const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

void main() {
  runApp(const MyApp());
}

// string 자료형 'prompt'문장을 입력받아서 chatGPT에게 질문하고 질문에 해당하는 답변 출력 함수
Future<String> generateText(String prompt) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    },
    body: jsonEncode({
      "model": "text-davinci-003",
      'prompt': prompt,
      'max_tokens': 1000,
      'temperature': 0,
      'top_p': 1,
      'frequency_penalty': 0,
      'presence_penalty': 0
    }),
  );

  Map<String, dynamic> newresponse =
      jsonDecode(utf8.decode(response.bodyBytes));

  print(newresponse);
  if (newresponse['choices'] != null && newresponse['choices'].isNotEmpty) {
    return newresponse['choices'][0]['text'];
  } else {
    throw Exception("No Text generated");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstPage(),
    );
  }
}
