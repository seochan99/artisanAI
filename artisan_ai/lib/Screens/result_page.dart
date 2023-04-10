import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final String prompt;

  const ResultPage({super.key, required this.prompt});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artisan AI Result"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
      ),
      // 입력받은 prompt를 출력
      body: Text(widget.prompt),
    );
  }
}
