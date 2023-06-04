import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  // 메시지 리스트
  final List<ChatMessage> _messages = [];
  OpenAI? chatGPT;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    chatGPT = OpenAI.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

// 메시지 전송
  void _sendMessgage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: 'user');
    setState(() {
      _messages.insert(0, message);
    });
    _controller.clear();

    final request = CompleteText(
      prompt: message.text,
      model: kChatGptTurbo,
      maxTokens: 200,
    );
    // _subscription = chatGPT!
    //     .builder("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",
    //         orgID: "")
    //     .onCompleteStream(request: request)
    //     .listen((event) {});
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessgage(),
            decoration: const InputDecoration.collapsed(
              hintText: "Send a message",
            ),
          ),
        ),
        // 전송 버튼
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => _sendMessgage(),
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ChatGPT Demo")),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                // 리스트뷰
                child: ListView.builder(
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
