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
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          TextButton(
              onPressed: () {
                String prompt = _controller.text;
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ResultPage(prompt: prompt)),
                );
              },
              child: const Text("Get Results"))
        ],
      ),
    );
  }
}
