import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/chat/list_user_in_group.dart';
import 'package:company_chat_app_demo/screens/chat/search_message.dart';
import 'package:company_chat_app_demo/screens/main_screen.dart';
import 'package:flutter/material.dart';

class ChatSettingScreen extends StatefulWidget {
  const ChatSettingScreen.direct(
      {super.key, required this.chatRoom, required this.userChat})
      : groupName = "";
  const ChatSettingScreen.group(
      {super.key, required this.chatRoom, required this.groupName})
      : this.userChat = null;
  final ChatRoom chatRoom;
  final String groupName;
  final UserChat? userChat;
  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rời khỏi đoạn chat?'),
        content: const Text(
            'Cuộc trò chuyện này sẽ được lưu trữ và bạn sẽ không nhận được bất kì tin nhắn mới nào nữa.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Hủy',
              style: TextStyle(
                color: Colors.blue[400],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await APIs.leaveTheGroupChat(
                  widget.chatRoom, APIs.firebaseAuth.currentUser!.uid);
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            },
            child: Text(
              'Rời',
              style: TextStyle(
                color: kColorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomName = widget.chatRoom.chatroomname!.isNotEmpty
        ? widget.chatRoom.chatroomname!
        : widget.groupName;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  widget.chatRoom.type!
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: widget.userChat!.imageUrl!.isNotEmpty
                              ? NetworkImage(widget.userChat!.imageUrl!)
                              : AssetImage('assets/images/group.png')
                                  as ImageProvider,
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: widget.chatRoom.imageUrl!.isNotEmpty
                              ? NetworkImage(widget.chatRoom.imageUrl!)
                              : AssetImage('assets/images/group.png')
                                  as ImageProvider,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.chatRoom.type!
                      ? Text(
                          widget.userChat!.username!,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          chatRoomName,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(
                    height: 50,
                  ),
                  widget.chatRoom.type!
                      ? Column(
                          children: [
                            InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              onTap:(){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchMessageScreen(chatroom: widget.chatRoom,)));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 55,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tìm kiếm trong cuộc trò chuyện',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(Icons.search)
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              "Thông tin về đoạn chat",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Card(
                              child: Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Xem thành viên trong đoạn chat"),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ListUserInGroup(
                                                      chatRoom:
                                                          widget.chatRoom),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.arrow_forward_ios),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Quyền riêng tư và hỗ trợ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Card(
                              child: Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: _showDialog,
                                        child: Row(
                                          children: [
                                            Icon(Icons.door_front_door),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Text("Rời khỏi đoạn chat")
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
