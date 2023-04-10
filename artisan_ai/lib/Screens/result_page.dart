import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ResultPage extends StatefulWidget {
  final String prompt;

  const ResultPage({super.key, required this.prompt});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
