import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat_setting.dart';
import 'package:company_chat_app_demo/widgets/chat_message.dart';
import 'package:company_chat_app_demo/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen.group(
      {super.key, required this.chatRoom, required this.groupName});
  ChatScreen.direct({super.key, required this.chatRoom}) : this.groupName = "";
  final ChatRoom chatRoom;
  final String groupName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            widget.chatRoom.type!
                ? CircleAvatar()
                : CircleAvatar(
                    backgroundImage: widget.chatRoom.imageUrl!.isNotEmpty
                        ? NetworkImage(widget.chatRoom.imageUrl!)
                        : AssetImage('assets/images/group.png')
                            as ImageProvider,
                  ),
            SizedBox(
              width: 10,
            ),
            widget.chatRoom.type!
                ? Container()
                : Container(
                    width: 225.4,
                    child: Text(
                      widget.chatRoom.chatroomname!.isNotEmpty
                          ? widget.chatRoom.chatroomname!
                          : widget.groupName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatSettingScreen.group(
                      chatRoom: widget.chatRoom, groupName: widget.groupName),
                ),
              );
            },
            icon: Icon(Icons.info),
          )
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessage()), NewMessage()],
      ),
    );
  }
}
