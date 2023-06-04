//홈 페이지 Home()

import 'package:flutter/material.dart';

import 'package:nau/index_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>?> user;
  bool nowLocation = false;
  String selectedKeyword = "한강"; // 선택한 키워드 초기값

// Set the latitude and longitude values

  dynamic userInfo = '';

  void handleKeywordSelected(String keyword) {
    setState(() {
      selectedKeyword = keyword;
    });
  }

  @override
  void initState() {
    super.initState();

    // user의 값이 null일때 loginScreen으로 이동하고 토큰값 지우기
    user.then((value) {
      if (value == null) {
        goLogin();
      }
    });
  }

  goLogin() async {
    gogoLogin();
  }

  gogoLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // 위도, 경도로 주소 가져오기
  // 주소 가져오기 (위도, 경도 -> 주소)
  // 주소 가져오기 (위도, 경도 -> 주소)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // 앱바의 뒤로가기 버튼을 없애기 위해 false로 설정

        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  const Text(
                    '내만산',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 18,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Expanded(child: SizedBox(width: 30)), // 여백 추가
            IconButton(
              padding: const EdgeInsets.only(left: 25),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IndexScreen()),
                );
              },
            ),
          ],
        ),
      ),
      // body
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 10, bottom: 20),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: nowLocation ? [] : [],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
