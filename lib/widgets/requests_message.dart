import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:flutter/material.dart';

class RequestsMessage extends StatefulWidget {
  const RequestsMessage(
      {super.key,
      required this.userChat,
      required this.chatRoomId,
      required this.reLoad});
  final UserChat userChat;
  final String chatRoomId;
  final void Function(bool onTap) reLoad;
  @override
  State<RequestsMessage> createState() => _RequestsMessageState();
}

class _RequestsMessageState extends State<RequestsMessage> {
  bool s = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundImage: widget.userChat.imageUrl!.isNotEmpty
              ? NetworkImage(widget.userChat.imageUrl!)
              : AssetImage('assets/images/user.png') as ImageProvider,
          radius: 60,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          widget.userChat.username!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Column(
                children: [
                  Icon(
                    Icons.handshake,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.userChat.username! + ' muốn kết nối với bạn',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kColorScheme.onPrimary,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Chặn',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kColorScheme.primary,
                          foregroundColor: kColorScheme.onPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            APIs.acceptRequestsMessage(widget.chatRoomId);
                            widget.reLoad(true);
                          });
                        },
                        child: Text(
                          'Chấp nhận',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
