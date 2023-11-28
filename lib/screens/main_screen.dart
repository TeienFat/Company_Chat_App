import 'package:company_chat_app_demo/screens/chat_home.dart';
import 'package:company_chat_app_demo/screens/contact.dart';
import 'package:company_chat_app_demo/screens/profile.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List pages = const [ContactScreen(), ChatHomeScreen(), ProfileScreen()];

  int currentIndex = 1;

  String title = 'Chats';

  void onTab(int index) {
    setState(() {
      currentIndex = index;
      switch (currentIndex) {
        case 0:
          title = 'Contacts';
          break;
        case 1:
          title = 'Chats';
          break;
        case 2:
          title = 'Profile';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 0),
        height: 83,
        child: BottomNavigationBar(
          onTap: onTab,
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.contacts_outlined,
                weight: 16,
                size: 30,
                color: Color(0xFF0F1828),
              ),
              label: 'Contacts',
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Contacts',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, height: 2.3),
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF0F1828),
                      shape: OvalBorder(),
                    ),
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 30,
                color: Color(0xFF0F1828),
              ),
              label: 'Chats',
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Chats',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, height: 2.3),
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF0F1828),
                      shape: OvalBorder(),
                    ),
                  ),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.person_3_outlined,
                size: 30,
                color: Color(0xFF0F1828),
              ),
              label: 'Profile',
              activeIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, height: 2.3),
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF0F1828),
                      shape: OvalBorder(),
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
