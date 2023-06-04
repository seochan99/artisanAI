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
        // Text(sender)
        //     .text
        //     .subtitle1(context)
        //     .make()
        //     .box
        //     .color(sender == "user"
        //         ? const Color.fromARGB(255, 172, 220, 255)
        //         : const Color.fromARGB(255, 187, 247, 218))
        //     .p16
        //     .rounded
        //     .alignCenter
        //     .makeCentered(),
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
              : text.trim().text.bodyText1(context).make().px8(),
        ),
      ],
    ).py8();
  }
}
