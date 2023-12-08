import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat.dart';
import 'package:flutter/material.dart';

class ChatRoomGroupChat extends StatelessWidget {
  ChatRoomGroupChat(
      {super.key, required this.chatRoom, required this.groupName});

  final ChatRoom chatRoom;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen.group(chatRoom: chatRoom, groupName: groupName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 16),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kColorScheme.primaryContainer,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: chatRoom.imageUrl != ''
                              ? NetworkImage(chatRoom.imageUrl!)
                              : AssetImage('assets/images/group.png')
                                  as ImageProvider,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )),
                // if (userchat.isOnline!)
                //   Positioned(
                //     right: -1,
                //     top: -1,
                //     child: Container(
                //       width: 17,
                //       height: 17,
                //       decoration: const BoxDecoration(
                //         color: Color.fromRGBO(44, 192, 105, 1),
                //         shape: BoxShape.circle,
                //         border: Border.symmetric(horizontal: BorderSide(width: 2,color: Colors.white),vertical: BorderSide(width: 2,color: Colors.white))
                //       ),
                //     ),
                //   ),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatRoom.chatroomname != ''
                      ? chatRoom.chatroomname!
                      : groupName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
