import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nau/main.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool isEditing = true;
  late String email;
  late String password;
  bool isInput = true;
  bool isSignIn = true;

  Future<void> fetchUserProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        setState(() {
          nameController.text = snapshot['name'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      print(uid);
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': nameController.text,
      });
      setState(() {
        isEditing = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 업데이트되었습니다.')),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 업데이트 중 오류가 발생했습니다.')),
      );
    }
  }

  signIn() async {
    try {
      // firebase 로그인
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user!.emailVerified) {
          setState(() {
            isInput = false;
          });
          goIndex();
        } else {
          showToast("Email Verified ERROR");
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong password provided for that user.");
      } else {
        print(e.code);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  // 로그아웃
  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      isInput = true;
    });
    // 로그인 화면 으로 이동
    goLogin();
  }

  goLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  goIndex() {
    Navigator.pushNamedAndRemoveUntil(context, '/index', (route) => false);
  }

  signUp() async {
    try {
      // firebase 회원가입
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value);

        if (value.user!.email != null) {
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          setState(() {
            isInput = false;
          });
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToast("The account already exists for that email.");
      } else {
        showToast("OTHER ERROR");
        print(e.code);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> getInputWidget() {
    return [
      // Text Form Field
      Text(
        isSignIn ? "로그인" : "회원 가입",
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),

      // Form
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // email
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'email'),
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      email = value ?? "";
                    },
                  ),
                  // password
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      password = value ?? "";
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  print("Email : $email, Password : $password");
                  if (isSignIn) {
                    signIn();
                  } else {
                    signUp();
                  }
                }
              },
              child: Text(isSignIn ? "로그인" : "회원 가입"),
            ),
          ],
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                  text: isSignIn ? "계정이 없으신가요?" : "계정이 있으신가요?",
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: const <TextSpan>[]),
            ),
            RichText(
                text: TextSpan(
              text: isSignIn ? "회원가입" : "로그인",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isSignIn = !isSignIn;
                  });
                },
            ))
          ],
        ),
      ),
    ];
  }

  List<Widget> getResultWidget() {
    String resultEmail = FirebaseAuth.instance.currentUser!.email!;
    return [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  isSignIn ? "로그인 계정" : resultEmail,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isSignIn)
                  Column(
                    children: [
                      // TextFormField(
                      //   controller: nameController,
                      //   decoration: const InputDecoration(
                      //     labelText: '이름',
                      //   ),
                      // ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     updateProfile();
                      //   },
                      //   child: const Text('프로필 업데이트'),
                      // ),
                    ],
                  ),
                const SizedBox(
                  height: 60,
                ),
                isSignIn
                    ? Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (isSignIn) {
                                goIndex();
                              } else {}
                            },
                            child: Text(isSignIn ? "NaU Bot 이동" : ""),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 70,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isSignIn) {
                      signOut();
                    } else {
                      setState(() {
                        isInput = true;
                        isSignIn = true;
                      });
                    }
                  },
                  child: Text(isSignIn ? "로그아웃" : "로그인"),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        title: const Text("NaU Bot"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: isInput ? getInputWidget() : getResultWidget(),
          ),
        ],
      ),
    );
  }
}
