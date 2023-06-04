import 'package:flutter/material.dart';

class BannerDetailScreen extends StatelessWidget {
  final String caption;
  final String content;

  const BannerDetailScreen({
    Key? key,
    required this.caption,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        title: const Text("나만의 지도, NUGU MAP"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Image.network(
                "https://velog.velcdn.com/images/seochan99/post/3a8993cf-63b0-4b08-b6bb-8ba625d81498/image.png",
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  children: _buildContentWithTitles(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildContentWithTitles() {
    final List<TextSpan> textSpans = [];
    final List<String> lines = content.split('\n');
    for (final line in lines) {
      if (line.startsWith('[title]')) {
        final title = line.substring(7);
        textSpans.add(
          TextSpan(
            text: '🎯 $title\n', // Include line breaks
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        textSpans.add(TextSpan(text: '$line\n')); // Include line breaks
      }
    }
    return textSpans;
  }
}
