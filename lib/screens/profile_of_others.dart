import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/nick_name.dart';
import 'package:flutter/material.dart';

class ProfileOfOthersScreen extends StatefulWidget {
  const ProfileOfOthersScreen({super.key});

  @override
  State<ProfileOfOthersScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileOfOthersScreen> {
  void nickNameUser() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => NickName(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<UserChat> lisUserchat;

    return FutureBuilder(
      future: APIs.getUserFormId(APIs.firebaseAuth.currentUser!.uid),
      builder: (context, userIDSnapShot) {
        if (userIDSnapShot.connectionState == ConnectionState.done) {
          UserChat userchat = userIDSnapShot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(20)),
                    CircleAvatar(
                      backgroundImage: userchat.imageUrl!.isNotEmpty
                          ? NetworkImage(userchat.imageUrl!) as ImageProvider
                          : AssetImage('assets/images/user.png')
                              as ImageProvider,
                      radius: 60,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userchat.username!,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wechat,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Nhắn tin',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(300, 40),
                            primary: kColorScheme.primary,
                            onPrimary: kColorScheme.onPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: nickNameUser,
                          icon: Icon(Icons.border_color_outlined),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Email" + " : " + userchat.email!,
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    ElevatedButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                              'Bạn có chắc chắn muốn chặn người này ?'),
                          content: const Text(
                              'Bạn sẽ không nhận được bất kỳ tin nhắn nào từ người này nữa'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.block),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Chặn",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(400, 50),
                        primary: kColorScheme.primary,
                        onPrimary: kColorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }
}
