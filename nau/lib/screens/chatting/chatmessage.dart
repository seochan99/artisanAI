import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.text,
    required this.sender,
    this.isImage = false,
  }) : super(key: key);

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

    final formattedText = getFormattedText();

    void saveImage() async {
      var imageBytes = await NetworkAssetBundle(Uri.parse(text)).load("");
      final result =
          await ImageGallerySaver.saveImage(imageBytes.buffer.asUint8List());
      if (result['isSuccess']) {
        // Image saved successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully')),
        );
      } else {
        // Saving image failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save image')),
        );
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
              ? GestureDetector(
                  onLongPress: saveImage,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      text,
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const CircularProgressIndicator.adaptive(),
                    ),
                  ),
                )
              : sender == "bot"
                  ? SelectableText(
                      text.trim(),
                    )
                  : Text(
                      formattedText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ).px8(),
        ),
      ],
    ).py8();
  }
}
