import 'package:artisan_ai/Screens/result_page.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController _controller = TextEditingController();

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
            const SizedBox(height: 20),
            // text입력창
            TextField(
              controller: _controller,
              // 데코레이션
              maxLength: 30,
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

            // text입력창에 입력된 text를 result_page.dart로 전달
            TextButton(
                onPressed: () {
                  String prompt = _controller.text;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ResultPage(prompt: prompt)),
                  );
                },
                child: const Text(
                  "Get Results",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
