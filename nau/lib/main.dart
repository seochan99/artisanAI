// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nau/auth_screen.dart';
import 'package:nau/firebase_options.dart';
import 'package:nau/index_screen.dart';
import 'package:nau/screens/image_input.dart';
import 'package:nau/tabs/tab_we_work.dart';

// toast messgaege
showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[300],
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '로그인 앱',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AuthWidget(),
      routes: {
        '/login': (context) => const AuthWidget(),
        '/index': (context) => const IndexScreen(),
        '/list': (context) => const WeWork(),
        '/input': (context) => const InputScreen(),
      },
    );
  }
}
