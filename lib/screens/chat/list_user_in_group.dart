import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/user_card_in_setting.dart';
import 'package:flutter/material.dart';

class ListUserInGroup extends StatefulWidget {
  const ListUserInGroup({super.key, required this.listUserId});
  final List<String> listUserId;
  @override
  State<ListUserInGroup> createState() => _ListUserInGroupState();
}

class _ListUserInGroupState extends State<ListUserInGroup> {
  @override
  Widget build(BuildContext context) {
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
              widget.listUserId.length.toString() + " thành viên",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListView.builder(
                  itemCount: widget.listUserId.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: APIs.getUserFormId(widget.listUserId[index]),
                      builder: (ctx, usersnapshot) {
                        if (usersnapshot.connectionState ==
                            ConnectionState.done) {
                          UserChat userchat = usersnapshot.data!;
                          return Column(
                            children: [
                              UserCardSetting(user: userchat),
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
