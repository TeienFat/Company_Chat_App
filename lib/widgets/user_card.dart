import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat.dart';
import 'package:company_chat_app_demo/widgets/menu_option_setting.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class UserCard extends StatefulWidget {
  const UserCard.contact({super.key, required this.user})
      : this.chatRoom = null,
        this.onTap = null,
        this.isNotChecked = null,
        this.room = 'contact';
  const UserCard.listParticipant(
      {super.key, required this.user, required this.chatRoom})
      : this.onTap = null,
        this.isNotChecked = null,
        this.room = 'listParticipants';
  const UserCard.createGroup(
      {super.key,
      required this.user,
      required this.onTap,
      required this.isNotChecked})
      : this.chatRoom = null,
        this.room = 'createGroup';

  final String room;
  final UserChat user;
  final ChatRoom? chatRoom;
  final void Function(UserChat user, bool isChecked)? onTap;
  final bool? isNotChecked;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future<void> goToChatScreen(BuildContext ctx) async {
    final chatRoomId = uuid.v4();

    ChatRoom chatRoom =
        await APIs.createDirectChatroom(widget.user.id!, chatRoomId);
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => ChatScreen.direct(
              chatRoom: chatRoom,
              userChat: widget.user,
            )));
  }

  void _openMenuOptionOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => MenuOptionSetting(
          chatRoom: widget.chatRoom!,
          userId: widget.user.id!,
          userName: widget.user.username!),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool? _isChecked;
    if (widget.isNotChecked != null) {
      _isChecked = widget.isNotChecked!;
    }
    return InkWell(
      onTap: () {
        switch (widget.room) {
          case 'contact':
            goToChatScreen(context);
            break;
          case 'listParticipants':
            _openMenuOptionOverlay();
          case 'createGroup':
            {
              setState(
                () {
                  _isChecked = !_isChecked!;
                  widget.onTap!(widget.user, _isChecked!);
                },
              );
            }
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 16),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: widget.user.imageUrl!.isNotEmpty
                        ? NetworkImage(widget.user.imageUrl!)
                        : AssetImage('assets/images/user.png') as ImageProvider,
                  ),
                ),
                if (widget.user.isOnline!)
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
                              horizontal:
                                  BorderSide(width: 2, color: Colors.white),
                              vertical:
                                  BorderSide(width: 2, color: Colors.white))),
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
                Text(
                  widget.user.username!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                widget.room == 'contact' || widget.room == 'createGroup'
                    ? (widget.user.isOnline!
                        ? const Text(
                            'Online',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(173, 181, 189, 1)),
                          )
                        : const Text(
                            'Offline',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(173, 181, 189, 1)),
                          ))
                    : const Text(
                        'Quản trị viên',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(173, 181, 189, 1)),
                      ),
              ],
            ),
            if (widget.room == 'createGroup') Spacer(),
            if (widget.room == 'createGroup')
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isChecked! ? kColorScheme.primary : null,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: kColorScheme.primary,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: _isChecked
                        ? Icon(
                            Icons.check,
                            size: 18.0,
                            color: Color.fromARGB(255, 244, 234, 234),
                          )
                        : Icon(
                            null,
                            size: 18.0,
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
