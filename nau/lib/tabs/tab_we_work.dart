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
  final String name;

  Content({
    // required this.title,
    required this.content,
    required this.downloadUrl,
    required this.date,
    required this.name,
  });

// json to content
  Content.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        downloadUrl = json['downloadUrl'],
        date = json['date'],
        name = json['name'];

// content to json
  Map<String, dynamic> toJson() => {
        'content': content,
        'downloadUrl': downloadUrl,
        'date': date,
        'name': name,
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
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            Colors.grey, // Set your desired border color here
                        width: 1.0, // Set your desired border width here
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // Set your desired border radius here
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "제목 : ${data.docs[index].data().content}",
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "작성자 : ${data.docs[index].data().name}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              data.docs[index].data().downloadUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
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
