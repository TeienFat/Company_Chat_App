import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:flutter/material.dart';

class ChangeNameImageGroup extends StatefulWidget {
  const ChangeNameImageGroup({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ChangeNameImageGroup> createState() => _Change_Name_Image_GroupState();
}

class _Change_Name_Image_GroupState extends State<ChangeNameImageGroup> {
  TextEditingController txtTenNhom = TextEditingController();
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
                    onPressed: () {},
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
