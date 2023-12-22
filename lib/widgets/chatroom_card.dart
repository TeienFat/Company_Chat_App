import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat.dart';
import 'package:company_chat_app_demo/widgets/menu_option_chatroom.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatefulWidget {
  ChatRoomCard.direct(
      {super.key, required this.chatRoom, required this.userchat})
      : this.groupName = '';
  ChatRoomCard.group(
      {super.key, required this.chatRoom, required this.groupName})
      : this.userchat = null;

  final ChatRoom chatRoom;
  final UserChat? userchat;
  final String groupName;

  @override
  State<ChatRoomCard> createState() => _ChatRoomCardState();
}

class _ChatRoomCardState extends State<ChatRoomCard> {
  MessageChat? _message;
  String? msg;
  void _openAddGroupOverlay(BuildContext ctx, String chatRoomId) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: ctx,
      builder: (context) => MenuOpTionChatRoom(chatRoomId: chatRoomId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        _openAddGroupOverlay(context, widget.chatRoom.chatroomid!);
      },
      onTap: () {
        if (widget.chatRoom.type!) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen.direct(
                    chatRoom: widget.chatRoom,
                    userChat: widget.userchat,
                  )));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen.group(
                  chatRoom: widget.chatRoom, groupName: widget.groupName),
            ),
          );
        }
      },
      child: StreamBuilder(
          stream: APIs.getLastMessage(widget.chatRoom.chatroomid!),
          builder: (context, lastMessageSnapshot) {
            if (lastMessageSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!lastMessageSnapshot.hasData ||
                lastMessageSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Không tìm thấy tin nhắn nào',
                ),
              );
            }
            if (lastMessageSnapshot.hasError) {
              return const Center(
                heightFactor: 10,
                child: Text(
                  'Có gì đó sai sai',
                ),
              );
            }
            final data = lastMessageSnapshot.data!.docs;
            final list =
                data.map((e) => MessageChat.fromMap(e.data())).toList();
            if (list.isNotEmpty) _message = list[0];
            switch (_message!.type) {
              case Type.image:
                msg = 'Đã gửi một ảnh';
                break;
              case Type.video:
                msg = 'Đã gửi một video';
                break;
              default:
                msg = _message!.msg;
            }
            if (_message!.fromId == APIs.firebaseAuth.currentUser!.uid &&
                _message!.type! != Type.sound) {
              msg = "Bạn: " + msg!;
            }
            if (_message!.fromId != APIs.firebaseAuth.currentUser!.uid &&
                _message!.type! != Type.sound) {
              msg = APIs.getLastWordOfName(_message!.userName!) + ": " + msg!;
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 12, top: 16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: widget.chatRoom.type!
                                        ? (widget.userchat!.imageUrl!.isNotEmpty
                                            ? NetworkImage(
                                                widget.userchat!.imageUrl!)
                                            : AssetImage(
                                                    'assets/images/user.png')
                                                as ImageProvider)
                                        : (widget.chatRoom.imageUrl != ''
                                            ? NetworkImage(
                                                widget.chatRoom.imageUrl!)
                                            : AssetImage(
                                                    'assets/images/group.png')
                                                as ImageProvider)),
                                borderRadius: BorderRadius.circular(16)),
                          )),
                      if (widget.chatRoom.type! && widget.userchat!.isOnline!)
                        Positioned(
                          right: -1,
                          top: -1,
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(44, 192, 105, 1),
                                shape: BoxShape.circle,
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        width: 2, color: Colors.white),
                                    vertical: BorderSide(
                                        width: 2, color: Colors.white))),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.chatRoom.type!
                          ? Text(
                              widget.userchat!.username!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )
                          : Text(
                              widget.chatRoom.chatroomname != ''
                                  ? widget.chatRoom.chatroomname!
                                  : widget.groupName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                      Row(
                        children: [
                          _message == null
                              ? SizedBox()
                              : Container(
                                  width: 190,
                                  child: _message!.read!.isEmpty &&
                                          _message!.fromId !=
                                              APIs.firebaseAuth.currentUser!.uid
                                      ? Text(
                                          msg!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          msg!,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(MyDateUtil.getLastMessageTime(
                              context: context, time: _message!.sent!)),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  _message == null
                      ? SizedBox()
                      : _message!.read!.isEmpty &&
                              _message!.fromId !=
                                  APIs.firebaseAuth.currentUser!.uid
                          ? Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : SizedBox()
                ],
              ),
            );
          }),
    );
  }
}
