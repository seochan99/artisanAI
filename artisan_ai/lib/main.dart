import 'dart:convert';
import 'dart:math';
import 'package:artisan_ai/Screens/first_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// api key
const apiUrl = 'https://api.openai.com/v1/completions';
const apiKey = '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';
String? inputText;
String imageUrl = 'https://api.openai.com/v1/images/generations';
String? image;
void main() {
  // await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

// string 자료형 'prompt'문장을 입력받아서 chatGPT에게 질문하고 질문에 해당하는 답변 출력 함수
// Futre 자료형은 비동기 함수를 사용할 때 사용
Future<String> generateText(String prompt) async {
  // response 변수에 chatGPT에게 질문한 결과를 저장
  final response = await http.post(
    // chatGPT에게 질문할 때 필요한 정보들을 담은 변수들을 http.post 메소드를 통해 전달
    Uri.parse(apiUrl),
    // chatGPT에게 질문할 때 필요한 정보들을 json 형태로 전달
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

  // chatGPT에게 질문한 결과를 json 형태로 변환
  Map<String, dynamic> newresponse =
      jsonDecode(utf8.decode(response.bodyBytes));
  print(newresponse);

  if (newresponse['choices'] != null && newresponse['choices'].isNotEmpty) {
    inputText = newresponse['choices'][0]['text'];

    return newresponse['choices'][0]['text'];
  } else {
    throw Exception(e);
  }
}

// string 자료형 'prompt'문장을 입력받아서 chatGPT에게 질문하고 질문에 해당하는 답변 출력 함수
void getAIImage() async {
  var data = {
    "prompt": inputText,
    "n": 1,
    "size": "256x256",
  };

  var res = await http.post(Uri.parse(imageUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json"
      },
      body: jsonEncode(data));

  var jsonResponse = jsonDecode(res.body);

  image = jsonResponse['data'][0]['imageUrl'];
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ChatGPT Demo",
      // 디버그 배너 제거
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        // 아래 코드로 인해 모든 Material 위젯의 기본 색상이 Colors.green으로 설정
        useMaterial3: true,
      ),
      // home: const ChatScreen(),
      home: const FirstPage(),
    );
  }
}
