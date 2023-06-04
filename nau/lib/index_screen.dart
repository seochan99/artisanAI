import 'package:flutter/material.dart';
import 'package:nau/tabs/tab_home.dart';
import 'package:nau/tabs/tab_my_work.dart';
import 'package:nau/tabs/tab_mypage.dart';
import 'package:nau/tabs/tab_we_work.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  dynamic userInfo = '';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  // goLogin() =>
  //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

  int currentIndex = 0;
  final List<Widget> tabs = [
    const Home(),
    const MyWork(), //임시
    const WeWork(),
    const Mypage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.all_inbox : Icons.all_inbox_outlined,
            ),
            label: '모두의 UI/UX',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.palette : Icons.palette_outlined,
            ),
            label: '나만의 UI/UX',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.person : Icons.person_outlined,
            ),
            label: '마이페이지',
          ),
        ],
      ),
      body: tabs[currentIndex],
    );
  }
}
