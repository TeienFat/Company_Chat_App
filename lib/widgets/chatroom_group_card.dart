import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatRoomGroupChat extends StatelessWidget {
  ChatRoomGroupChat({super.key,required this.chatroom});

  final ChatRoom chatroom;

  @override
  Widget build(BuildContext context) {
    return InkWell (
      onTap: () {
        
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
                        image: AssetImage('assets/images/user.png')
                      ),
                      borderRadius: BorderRadius.circular(16)),
                  )
                ),
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
                Text("Nhóm1",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
              ],
            )
          ],
        ),
      ),
    );
  }
}