import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat.dart';
import 'package:company_chat_app_demo/widgets/menu_option_chatroom.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatelessWidget {
  ChatRoomCard.direct({super.key,required this.chatRoom, required this.userchat}): this.groupName = '';
  ChatRoomCard.group({super.key,required this.chatRoom, required this.groupName}): this.userchat = null;

  final ChatRoom chatRoom;
  final UserChat? userchat;
  final String groupName;

  void _openAddGroupOverlay(BuildContext ctx,String chatRoomId) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: ctx,
      builder: (context) => MenuOpTionChatRoom(chatRoomId: chatRoomId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell (
      onLongPress: (){
        _openAddGroupOverlay(context,chatRoom.chatroomid!);
      },
      onTap: () {
        if(chatRoom.type!){
           Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                ChatScreen.direct(chatRoom: chatRoom,userChat: userchat,)));
        }
        else{
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
              ChatScreen.group(chatRoom: chatRoom, groupName: groupName),
          ),
        );
        }
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
                        image: chatRoom.type! 
                        ? (userchat!.imageUrl!.isNotEmpty
                          ? NetworkImage(userchat!.imageUrl!)
                          : AssetImage('assets/images/user.png') as ImageProvider)
                        : (chatRoom.imageUrl != ''
                              ? NetworkImage(chatRoom.imageUrl!)
                              : AssetImage('assets/images/group.png')
                                  as ImageProvider)
                      ),
                      borderRadius: BorderRadius.circular(16)),
                  )
                ),
                if (chatRoom.type! && userchat!.isOnline!)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(44, 192, 105, 1),
                        shape: BoxShape.circle,
                        border: Border.symmetric(horizontal: BorderSide(width: 2,color: Colors.white),vertical: BorderSide(width: 2,color: Colors.white))
                      ),
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
                chatRoom.type!
                ? Text(userchat!.username!,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                : Text(
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