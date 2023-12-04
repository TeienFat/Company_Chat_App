import 'package:company_chat_app_demo/screens/chat/chat_setting.dart';
import 'package:company_chat_app_demo/widgets/chat_message.dart';
import 'package:company_chat_app_demo/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'username',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ChatSettingScreen()));
            },
            icon: Icon(Icons.info)
          )
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessage()), NewMessage()],
      ),
    );
  }
}
