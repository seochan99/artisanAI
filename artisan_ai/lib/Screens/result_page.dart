import 'package:artisan_ai/main.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  final String prompt;
  final String myText;
  final String? image;

  const ResultPage(
      {super.key, required this.prompt, required this.myText, this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  TextEditingController inputText = TextEditingController();
  String apikey = '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';
  String url = 'https://api.openai.com/v1/images/generations';
  String? image;
  void getAIImage() async {
    if (inputText.text.isNotEmpty) {
      var data = {
        "prompt":
            "${inputText.text}, User Experience, UI/UX designer,designer ",
        "n": 1,
        "size": "256x256",
      };

      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer $apikey",
            "Content-Type": "application/json"
          },
          body: jsonEncode(data));

      var jsonResponse = jsonDecode(res.body);

      image = jsonResponse['data'][0]['url'];
      setState(() {});
    } else {
      print("Enter something");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 버튼
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Artisan AI Result"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      // 입력받은 prompt를 출력
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Text(
              "내가 입력한 문장",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.myText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),

            // 답변 박스
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<String>(
                future: generateText(widget.prompt),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ));
                  } else if (snapshot.hasError) {
                    return Text("ERROR : ${snapshot.error}");
                  } else {
                    return Column(
                      children: [
                        // 복사
                        GestureDetector(
                          // 답변 클릭 시 복사
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: snapshot.data));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('복사되었습니다.')),
                            );
                          },
                          child: Text(
                            '${snapshot.data}', // 답변
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Text(
                          "클릭해서 복사하세요!",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            image != null
                ? Image.network(image!, width: 256, height: 265)
                : Container(
                    child: const Text("Please Enter Text To Generate AI image"),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: inputText,
                decoration: const InputDecoration(
                    hintText: "Please enter your prompt",
                    icon: Icon(Icons.send, color: Colors.black),
                    filled: true,
                    // 인풋 클릭 전 테두리 색상
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    // 인풋 클릭시 테두리 색상
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),
            TextButton(
                onPressed: () {
                  getAIImage();
                },
                child: const Text(
                  "Generate AI Image",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
