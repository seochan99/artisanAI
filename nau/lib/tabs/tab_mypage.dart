import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  late User? currentUser;
  late TextEditingController nameController;
  late TextEditingController contentController;
  late XFile? profileImageFile; // Stores the selected profile image file
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    nameController =
        TextEditingController(text: currentUser?.displayName ?? '');
    contentController = TextEditingController(text: '');

    fetchUserProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> fetchUserProfile() async {
    try {
      String uid = currentUser?.uid ?? '';
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        setState(() {
          contentController.text = snapshot['content'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateProfile() async {
    try {
      final displayName = nameController.text;
      final content = contentController.text;

      await currentUser?.updateDisplayName(displayName);

      // Upload the profile image to Firebase Storage if a file is selected
      if (profileImageFile != null) {
        String profileImagePath = 'profile_images/${currentUser?.uid}.jpg';
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child(profileImagePath);
        await storageRef.putFile(File(profileImageFile!.path));
        String downloadURL = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .update({
          'profileImage': downloadURL,
        });
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .update({
        'name': displayName,
        'content': content,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 업데이트되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 업데이트 중 오류가 발생했습니다.')),
      );
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40.0),
            GestureDetector(
              onTap: isEditing ? pickImage : null,
              child: const CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/78739194?v=4"),
              ),
            ),
            TextFormField(
              controller: nameController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: '이름',
              ),
            ),
            TextFormField(
              controller: contentController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: '자기 소개',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: isEditing ? updateProfile : null,
              child: const Text('프로필 업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}
