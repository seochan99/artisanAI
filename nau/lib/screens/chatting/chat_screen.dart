import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool _isImageSearch = false;
  bool _isTyping = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
      token: dotenv.env["API_KEY"],
      baseOption: HttpSetup(
        receiveTimeout: const Duration(milliseconds: 60000),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: "${_controller.text}UI/UX Design ${_isWebPlatform ? "Web" : "App"}",
      sender: "user",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    if (_isImageSearch) {
      final request = GenerateImage(message.text, 1, size: "256x256");

      final response = await chatGPT!.generateImage(request);
      Vx.log(response!.data!.last!.url!);
      insertNewData(response.data!.last!.url!, isImage: true);
    } else {
      final request = CompleteText(prompt: message.text, model: kTextDavinci3);

      final response = await chatGPT!.onCompletion(request: request);
      Vx.log(response!.choices[0].text);
      insertNewData(response.choices[0].text, isImage: false);
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  bool _isWebPlatform = false;
  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration.collapsed(
                hintText: "원하시는 UI를 입력해주세요!",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _isImageSearch = false;
              _sendMessage();
            },
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Select Platform"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _isWebPlatform = true;
                          // String appendedText = ", Web Design";
                          // _controller.text += appendedText;
                          Navigator.of(context).pop();
                        },
                        child: const Text("Web"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _isWebPlatform = false;
                          // String appendedText = ", App Design";
                          // _controller.text += appendedText;
                          Navigator.of(context).pop();
                        },
                        child: const Text("App"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _isImageSearch = true;
                        Navigator.of(context).pop();
                        _sendMessage();
                      },
                      child: const Text("Generate Image"),
                    ),
                  ],
                ),
              );
            },
            child: const Text("Select Platform"),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 이미지 공유 로직 구현
              shareImage();
            },
          ),
        ],
      ),
    );
  }

  void shareImage() {
    // 이미지 공유 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // 이미지를 이메일로 공유하는 로직 구현
                shareViaEmail();
                Navigator.of(context).pop();
              },
              child: const Text("Share via Email"),
            ),
            ElevatedButton(
              onPressed: () {
                // 이미지를 소셜 미디어로 공유하는 로직 구현
                shareViaSocialMedia();
                Navigator.of(context).pop();
              },
              child: const Text("Share via Social Media"),
            ),
          ],
        ),
      ),
    );
  }

  void shareViaEmail() {
    // 이메일 공유 로직 구현
  }

  void shareViaSocialMedia() {
    // 소셜 미디어 공유 로직 구현
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UI/UX Chatbot")),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: Vx.m8,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            if (_isTyping) const ThreeDots(),
            const Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}
