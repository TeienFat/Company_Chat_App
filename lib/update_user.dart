import 'dart:io';
import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/menu_pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key, required this.userChat});
  final UserChat? userChat;
  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController txtUserName = TextEditingController();

  void _updateImages(bool pickerType) async {
    var pickedImage;
    if (pickerType) {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 295,
      );
      if (pickedImage == null) {
        return;
      }
      await APIs.updateImageUser(widget.userChat!.id!, File(pickedImage.path),
          widget.userChat!.imageUrl!);
    } else {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 295,
      );
      if (pickedImage == null) {
        return;
      }
      await APIs.updateImageUser(widget.userChat!.id!, File(pickedImage.path),
          widget.userChat!.imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    txtUserName.text = widget.userChat!.username!;
    return FutureBuilder(
      future: APIs.getUserFormId(APIs.firebaseAuth.currentUser!.uid),
      builder: (context, userIDSnapShot) {
        if (userIDSnapShot.connectionState == ConnectionState.done) {
          UserChat userchat = userIDSnapShot.data!;
          return Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(20)),
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: userchat.imageUrl!.isNotEmpty
                          ? NetworkImage(userchat.imageUrl!) as ImageProvider
                          : AssetImage('assets/images/user.png')
                              as ImageProvider,
                      radius: 60,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: kColorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                useSafeArea: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => MenuPickImage(
                                  onPickImage: (type) => _updateImages(type),
                                ),
                              );
                            },
                            iconSize: 25,
                            icon: Icon(
                              Icons.camera_alt_sharp,
                              color: kColorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Đổi tên',
                      border: OutlineInputBorder(),
                    ),
                    controller: txtUserName,
                  ),
                ),
                SizedBox(
                  height: 450,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await APIs.updateUserName(txtUserName.text);
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
