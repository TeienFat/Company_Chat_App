import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController txtUserName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<UserChat> lisUserchat;
    return FutureBuilder(
      future: APIs.getUserFormId(APIs.firebaseAuth.currentUser!.uid),
      builder: (context, userIDSnapShot) {
        if (userIDSnapShot.connectionState == ConnectionState.done) {
          UserChat userchat = userIDSnapShot.data!;
          return Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(20)),
                CircleAvatar(
                  backgroundImage: userchat.imageUrl!.isNotEmpty
                      ? NetworkImage(userchat.imageUrl!) as ImageProvider
                      : AssetImage('assets/images/user.png') as ImageProvider,
                  radius: 60,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: txtUserName,
                    decoration: InputDecoration(
                      label: Text(
                        'Tên',
                        style: TextStyle(fontSize: 20),
                      ),
                      hintText: userchat.username,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 470,
                ),
                ElevatedButton(
                  onPressed: () {
                    UserChat userChat = UserChat(
                      id: null,
                      imageUrl: null,
                      username: txtUserName.text,
                      isOnline: null,
                      email: null,
                      blockUsers: null,
                      token: ""
                    );
                    APIs.updateUserFormId(userChat);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_document,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Cập nhật',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(380, 50),
                    primary: kColorScheme.primary,
                    onPrimary: kColorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          );
        } else
          return Container();
      },
    );
  }
}
