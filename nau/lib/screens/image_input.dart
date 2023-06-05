import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nau/tabs/tab_we_work.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final controller = TextEditingController();
  bool isImageVisible = false;
  XFile? _image;
  String? downloadURL;
  String? name;

  @override
  void dispose() {
    controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  Future getGalleryImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      isImageVisible = true;
    });
  }

  uploadFile() async {
    if (_image == null) {
      showToast("no file selected");
      return null;
    }

    // Create a Reference to the file
    Reference ref =
        FirebaseStorage.instance.ref().child("image/${_image?.name}");

    await ref.putFile(File(_image!.path));
    downloadURL = await ref.getDownloadURL();
    print(downloadURL);
  }

  _save() async {
    await uploadFile();
    if (_image == null || downloadURL == null || controller.text.isEmpty) {
      showToast("INVALID SAVE DATA");
      return null;
    }

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('contents');

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        setState(() {
          name = snapshot['name'];
        });
      }

      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      Content content = Content(
        content: controller.text,
        downloadUrl: downloadURL!,
        date: dateFormat.format(DateTime.now()),
        name: name!,
      );
      await collectionRef.add(content.toJson());
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 올리기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_album_outlined),
            onPressed: () {
              getGalleryImage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_outlined),
            onPressed: () {
              _save();
            },
          ),
        ],
        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        Visibility(
          visible: isImageVisible,
          child: isImageVisible
              ? SizedBox(
                  height: 200,
                  child: _image != null
                      ? Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        )
                      : Container(),
                )
              : Container(),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
              style: const TextStyle(fontSize: 20),
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '내용',
                prefixIcon: Icon(Icons.input),
                hintText: "내용을 입력해주세요.",
                helperText: "내용을 입력해주세요.",
              )),
        )
      ]),
    );
  }
}
