import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  List<MessageChat> listMessage = [];

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
        listMessage = data.map((e) => MessageChat.fromMap(e.data())).toList();
        listMessage.sort((a, b) {
          if (int.parse(a.sent!) > (int.parse(b.sent!))) {
            return 0;
          }
          return 1;
        });

        return ListView.builder(
          padding: const EdgeInsets.all(13),
          reverse: true,
          itemCount: listMessage.length,
          itemBuilder: (context, index) {
            final chatMessage = listMessage[index];
            final nextChatMessage =
                index + 1 < listMessage.length ? listMessage[index + 1] : null;
            final prevChatMessage =
                index - 1 >= 0 ? listMessage[index - 1] : null;
            final currentMessageUserId = chatMessage.fromId;
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage.fromId : null;
            final prevMessageUserId =
                prevChatMessage != null ? prevChatMessage.fromId : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            final prevUserIsSame = prevMessageUserId == currentMessageUserId;
            if (chatMessage.type == Type.sound) {
              return Center(
                  child: Text(
                chatMessage.msg!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ));
            }
            if (APIs.firebaseAuth.currentUser!.uid == currentMessageUserId &&
                prevChatMessage != null &&
                prevChatMessage.read == '') {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: true,
                isLastInSequence: false,
                isLastMessage: true,
                typeChat: widget.chatRoom.type!,
              );
            }

            if (prevChatMessage == null &&
                APIs.firebaseAuth.currentUser!.uid == currentMessageUserId) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: true,
                isLastInSequence: true,
                isLastMessage: true,
                typeChat: widget.chatRoom.type!,
              );
            }
            if (!prevUserIsSame &&
                !nextUserIsSame &&
                currentMessageUserId != APIs.firebaseAuth.currentUser!.uid) {
              return MessageBubble.first(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe:
                    APIs.firebaseAuth.currentUser!.uid == currentMessageUserId,
                isLastInSequence: true,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
              );
            }

            if (!prevUserIsSame) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe:
                    APIs.firebaseAuth.currentUser!.uid == currentMessageUserId,
                isLastInSequence: true,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
              );
            }

            if (currentMessageUserId == APIs.firebaseAuth.currentUser!.uid ||
                nextUserIsSame) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe:
                    APIs.firebaseAuth.currentUser!.uid == currentMessageUserId,
                isLastInSequence: false,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
              );
            } else
              return MessageBubble.first(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe:
                    APIs.firebaseAuth.currentUser!.uid == currentMessageUserId,
                isLastInSequence: false,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
              );
          },
        );
      },
    );
  }
}
