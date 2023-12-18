import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/user_card.dart';
import 'package:flutter/material.dart';

class ListUserInGroup extends StatefulWidget {
  const ListUserInGroup({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ListUserInGroup> createState() => _ListUserInGroupState();
}

class _ListUserInGroupState extends State<ListUserInGroup> {
  @override
  Widget build(BuildContext context) {
    List<String> listUserId = widget.chatRoom.participants!.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Thành viên đoạn chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listUserId.length.toString() + " thành viên",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListView.builder(
                  itemCount: listUserId.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: APIs.getUserFormId(listUserId[index]),
                      builder: (ctx, usersnapshot) {
                        if (usersnapshot.connectionState ==
                            ConnectionState.done) {
                          UserChat userchat = usersnapshot.data!;
                          return Column(
                            children: [
                              UserCard.listParticipant(
                                  chatRoom: widget.chatRoom, user: userchat),
                              Divider(
                                height: 3,
                              )
                            ],
                          );
                        } else
                          return Container();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
