import 'package:flutter/material.dart';

class ChatSettingScreen extends StatefulWidget {
  const ChatSettingScreen({super.key});

  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20,right: 5,left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  Text('12321',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
