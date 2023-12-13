import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  //final UserChat userchat;
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  List<Message> listMessage = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APIs.getAllMessages(widget.chatRoom.chatroomid!),
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
            child: widget.chatRoom.isRequests == null
                ? Column(
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
                  )
                : SizedBox(),
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
        final data = messageSnapshot.data!.docs;
        listMessage = data.map((e) => Message.fromMap(e.data())).toList();
        return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: listMessage.length,
            itemBuilder: (context, index) {
              final chatMessage = listMessage[index];
              final nextChatMessage = index + 1 < listMessage.length
                  ? listMessage[index + 1]
                  : null;
              final currentMessageUserId = chatMessage.fromId;
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage.fromId : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;
              if (currentMessageUserId == APIs.firebaseAuth.currentUser!.uid ||
                  nextUserIsSame) {
                return MessageBubble.second(
                    text: chatMessage.msg!,
                    isMe: APIs.firebaseAuth.currentUser!.uid ==
                        currentMessageUserId);
              } else {
                return MessageBubble.first(
                    userName: chatMessage.userName,
                    userImage: chatMessage.userImage!,
                    text: chatMessage.msg!,
                    isMe: APIs.firebaseAuth.currentUser!.uid ==
                        currentMessageUserId);
              }
            });
      },
    );
  }
}
