import 'package:artisan_ai/Screens/result_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController _controller = TextEditingController();
  TextEditingController inputText = TextEditingController();
  bool isWeb = false; // 추가: 앱 또는 웹 여부를 나타내는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artisan AI"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: _controller,
              maxLength: 30,
              decoration: const InputDecoration(
                hintText: "Please enter your prompt",
                icon: Icon(Icons.send, color: Colors.black),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String myText = _controller.text;
                String additionalText = isWeb
                    ? "Web Design"
                    : "APP Design"; // 추가: 앱 또는 웹에 따른 문자열 설정
                String prompt =
                    "${_controller.text}, Please let me know in the form of a prompt that separates functions by commas. For example, UI/UX, design, and User Interface, $additionalText";
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultPage(prompt: prompt, myText: myText),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: const Text(
                "Get Results",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
