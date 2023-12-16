import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/update_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void capNhatThongTin() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => UpdateUser(),
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
              Text(
                userchat.username!,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Email" + " : " + userchat.email!,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 360,
              ),
              ElevatedButton(
                onPressed: capNhatThongTin,
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
                      'Cập nhật thông tin',
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
          ));
        } else
          return Container();
      },
    );
  }
}
