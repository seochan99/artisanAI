import 'package:artisan_ai/main.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final String prompt;
  final String myText;

  const ResultPage({super.key, required this.prompt, required this.myText});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(widget.myText),
          const SizedBox(height: 20),
          FutureBuilder<String>(
            future: generateText(widget.prompt),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("ERROR : ${snapshot.error}");
              } else {
                return Text('${snapshot.data}');
              }
            },
          )
        ],
      ),
    );
  }
}
