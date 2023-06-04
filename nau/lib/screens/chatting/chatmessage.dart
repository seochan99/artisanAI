import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    String getFormattedText() {
      if (text.contains("high")) {
        final parts = text.split("high");
        return parts.first.trim();
      } else if (text.contains("Please")) {
        final parts = text.split("Please");
        return parts.first.trim();
      } else {
        return text;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sender == "bot"
            ? const CircleAvatar(
                backgroundImage: AssetImage("assets/images/icon.png"),
              ).pOnly(right: 16)
            : const CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/78739194?v=4",
                ),
                backgroundColor: Colors.white,
              ).pOnly(right: 16),
        Expanded(
            child: isImage
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      text,
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const CircularProgressIndicator.adaptive(),
                    ),
                  )
                : sender == "bot"
                    ? text.trim().text.bodyText1(context).make().px8()
                    : Text(
                        getFormattedText(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ).px8()),
      ],
    ).py8();
  }
}
