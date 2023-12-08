import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final UserChat user;

  Future<void> goToChatScreen(BuildContext ctx) async {
      final chatRoomId = uuid.v4();
      
      ChatRoom chatRoom = await APIs.createDirectChatroom(user.id!, chatRoomId);
    Navigator.of(ctx).push(MaterialPageRoute(builder: (context) =>  ChatScreen.direct(chatRoom: chatRoom)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await goToChatScreen(context);
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
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: user.imageUrl!.isNotEmpty
                                  ? NetworkImage(user.imageUrl!)
                                  : AssetImage('assets/images/user.png')
                                      as ImageProvider),
                          borderRadius: BorderRadius.circular(16)),
                    )),
                if (user.isOnline!)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(44, 192, 105, 1),
                          shape: BoxShape.circle,
                          border: Border.symmetric(
                              horizontal:
                                  BorderSide(width: 2, color: Colors.white),
                              vertical:
                                  BorderSide(width: 2, color: Colors.white))),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                user.isOnline!
                    ? const Text(
                        'Online',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(173, 181, 189, 1)),
                      )
                    : const Text(
                        'Offline',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(173, 181, 189, 1)),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
