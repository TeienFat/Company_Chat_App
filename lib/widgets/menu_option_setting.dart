import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/screens/profile_of_others.dart';
import 'package:flutter/material.dart';

class MenuOptionSetting extends StatelessWidget {
  const MenuOptionSetting(
      {super.key,
      required this.chatRoom,
      required this.userId,
      required this.userName});
  final ChatRoom chatRoom;
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    String UsesID = userId;
    String username = APIs.getLastWordOfName(userName);
    Future<void> _showDialog(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Xóa $username ra khỏi nhóm?'),
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
                await APIs.leaveTheGroupChat(chatRoom, userId);
                Navigator.pop(context);
              },
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: kColorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight / 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _showDialog(context);
                  },
                  child: Container(
                    height: constraints.maxHeight / 12,
                    decoration: BoxDecoration(
                        border: Border.symmetric(
                            horizontal:
                                BorderSide(width: 1, color: Colors.grey))),
                    width: constraints.maxWidth,
                    child: Center(
                      child: Text(
                        "Xóa khỏi đoạn chat",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileOfOthersScreen(id: UsesID)));
                  },
                  child: Container(
                    height: constraints.maxHeight / 12,
                    decoration: BoxDecoration(
                        border: Border.symmetric(
                            horizontal:
                                BorderSide(width: 1, color: Colors.grey))),
                    width: constraints.maxWidth,
                    child: Center(
                      child: Text(
                        "Xem thông tin cá nhân",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: constraints.maxHeight / 12,
                    decoration: BoxDecoration(
                        border: Border.symmetric(
                            horizontal:
                                BorderSide(width: 1, color: Colors.grey))),
                    width: constraints.maxWidth,
                    child: Center(
                      child: Text(
                        "Đóng",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
