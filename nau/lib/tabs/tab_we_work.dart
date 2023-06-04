import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// toast messgae
showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

// content Class
class Content {
  // final String title;
  final String content;
  final String downloadUrl;
  final String date;

  Content({
    // required this.title,
    required this.content,
    required this.downloadUrl,
    required this.date,
  });

// json to content
  Content.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        downloadUrl = json['downloadUrl'],
        date = json['date'];

// content to json
  Map<String, dynamic> toJson() => {
        'content': content,
        'downloadUrl': downloadUrl,
        'date': date,
      };
}

class WeWork extends StatefulWidget {
  const WeWork({super.key});

  @override
  State<WeWork> createState() => _WeWorkState();
}

class _WeWorkState extends State<WeWork> {
  // firestore instance
  final contentRef = FirebaseFirestore.instance
      .collection('contents')
      .withConverter<Content>(
        fromFirestore: (snapshots, _) => Content.fromJson(snapshots.data()!),
        toFirestore: (content, _) => content.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('모두의 UI/UX'),
        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Content>>(
          stream: contentRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(data.docs[index].data().downloadUrl),
                      Text(
                        data.docs[index].data().content,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/input');
        },
        tooltip: "add",
        child: const Icon(Icons.add),
      ),
    );
  }
}
