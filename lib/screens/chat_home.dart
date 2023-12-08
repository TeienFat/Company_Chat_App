import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/chatroom_card.dart';
import 'package:company_chat_app_demo/widgets/chatroom_group_card.dart';
import 'package:flutter/material.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List<ChatRoom> _listChatroom = [];

  void _runFilter(String enteredKeyword) {}

  int _getIndex(String id, List<String> list) {
    return list.indexOf(id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          searchBar(_runFilter),
          StreamBuilder(
            stream: APIs.getAllChatroom(),
            builder: (ctx, chatroomSnapshot) {
              if (chatroomSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  heightFactor: 10,
                  child: CircularProgressIndicator(),
                );
              }
              if (!chatroomSnapshot.hasData ||
                  chatroomSnapshot.data!.docs.isEmpty) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Không tìm thấy đoạn chat nào',
                  ),
                );
              }
              if (chatroomSnapshot.hasError) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Có gì đó sai sai',
                  ),
                );
              }
              final data = chatroomSnapshot.data!.docs;
              _listChatroom = data
                  .map<ChatRoom>((e) => ChatRoom.fromMap(e.data()))
                  .toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: _listChatroom.length,
                  itemBuilder: (ctx, index) {
                    bool typeRoom = _listChatroom[index].type!;
                     List<String> userIdLisst = _listChatroom[index].participants!.keys.toList();

                        String userid = userIdLisst.elementAt(0);

                        if(userid == APIs.firebaseAuth.currentUser!.uid)
                          userid = userIdLisst.elementAt(1);
                    if (typeRoom) {
                      return FutureBuilder(
                        future: APIs.getUserFormId(userid.toString()),
                        builder: (ctx, usersnapshot) {
                          if (usersnapshot.connectionState ==
                              ConnectionState.done) {
                            UserChat userchat = usersnapshot.data!;
                            return ChatRoomCard(
                                chatRoom: _listChatroom[index],
                                userchat: userchat);
                          } else
                            return Container();
                        },
                      );
                    }
                    // return FutureBuilder(
                    //     future: APIs.getChatRoomName(_listChatroom[index]),
                    //     builder: (ctx, usersnapshot) {
                    //       if (usersnapshot.connectionState ==
                    //           ConnectionState.done) {
                    //         String groupName = usersnapshot.data!;
                    //         return ChatRoomGroupChat(
                    //           chatRoom: _listChatroom[index],
                    //           groupName: groupName,
                    //         );
                    //       } else
                    //         return Container();
                    //     });
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
