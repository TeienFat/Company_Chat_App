import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APIs.getAllMessages(widget.chatRoom),
      builder: (context, messageSnapshot) {
        if (messageSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            heightFactor: 10,
            child: CircularProgressIndicator(),
          );
        }
        if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
          return Center(
            heightFactor: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.waving_hand_rounded,
                  color: kColorScheme.primary,
                  size: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Say Hi!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        }
        if (messageSnapshot.hasError) {
          return const Center(
            heightFactor: 10,
            child: Text(
              'Có gì đó sai sai',
            ),
          );
        }
        final loadedMessages = messageSnapshot.data!.docs;
        return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              final chatMessage = loadedMessages[index].data();
              return Text(chatMessage['msg']);
            });
      },
    );
  }
}
