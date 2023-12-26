import 'dart:io';

import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/widgets/menu_pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeNameImageGroup extends StatefulWidget {
  const ChangeNameImageGroup({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ChangeNameImageGroup> createState() => _Change_Name_Image_GroupState();
}

class _Change_Name_Image_GroupState extends State<ChangeNameImageGroup> {
  TextEditingController txtTenNhom = TextEditingController();
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
      await APIs.updateImageChatRoom(widget.chatRoom.chatroomid!,
          File(pickedImage.path), widget.chatRoom.imageUrl!);
    } else {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 295,
      );
      if (pickedImage == null) {
        return;
      }
      await APIs.updateImageChatRoom(widget.chatRoom.chatroomid!,
          File(pickedImage.path), widget.chatRoom.imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIs.getChatRoomFromId(widget.chatRoom.chatroomid!),
        builder: (context, chatRomIDSnapShot) {
          if (chatRomIDSnapShot.connectionState == ConnectionState.done) {
            ChatRoom chatroom = chatRomIDSnapShot.data!;
            txtTenNhom.text = chatroom.chatroomname!;
            return Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(10.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        "Thay đổi hình ảnh",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await APIs.updateNameChatRoom(
                              widget.chatRoom.chatroomid!, txtTenNhom.text);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Xong',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CircleAvatar(
                    backgroundImage: chatroom.imageUrl!.isNotEmpty
                        ? NetworkImage(chatroom.imageUrl!) as ImageProvider
                        : AssetImage('assets/images/group.png')
                            as ImageProvider,
                    radius: 60,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => MenuPickImage(
                          onPickImage: (type) => this._updateImages(type),
                        ),
                      );
                    },
                    icon: Icon(Icons.camera_alt_rounded),
                  ),
                  Text(
                    'Tải ảnh lên',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: txtTenNhom,
                      decoration: InputDecoration(
                        labelText: 'Đặt tên nhóm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else
            return Container();
        });
  }
}
