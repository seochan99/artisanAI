import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MyWork extends StatefulWidget {
  const MyWork({Key? key}) : super(key: key);

  @override
  _MyWorkState createState() => _MyWorkState();
}

class _MyWorkState extends State<MyWork> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  String? generatedImageURL;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUserMessage: true,
      ));

      _controller.clear();
    });

    _fetchChatGPTResponse(text);
  }

  Future<void> _fetchChatGPTResponse(String text) async {
    await dotenv.load(fileName: 'assets/config/.env');
    const url = 'https://api.openai.com/v1/chat/completions';

    final requestBody = {
      'prompt': 'Your prompt: $text',
      'max_tokens': 50,
      'temperature': 0.6,
      'n': 1,
      'stop': '\n',
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${dotenv.env['OPEN_AI_API_KEY']}",
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final chatGPTResponse = data['choices'][0]['text'].toString().trim();

      setState(() {
        _messages.add(ChatMessage(
          text: chatGPTResponse,
          isUserMessage: false,
        ));
      });

      _generateDALLEImage(chatGPTResponse);
    } else {
      print('Failed to fetch ChatGPT response.');
    }
  }

  Future<void> _generateDALLEImage(String prompt) async {
    await dotenv.load(fileName: 'assets/config/.env');
    const url = 'https://api.openai.com/v1/images';

    final requestBody = {
      'prompt': prompt,
      'models': ['dalle-2'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['OPEN_AI_API_KEY']}',
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageID = data['images'][0];
      final imageURL = 'https://dalle-api.openai.com/images/$imageID.png';

      setState(() {
        generatedImageURL = imageURL;
      });
    } else {
      print('Failed to generate DALL-E image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.text),
                  tileColor: message.isUserMessage ? Colors.blue : Colors.grey,
                );
              },
            ),
          ),
          if (generatedImageURL != null)
            Image.network(
              generatedImageURL!,
              width: 300,
              height: 300,
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(_controller.text),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
  });
}
