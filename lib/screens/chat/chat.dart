import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/screens/chat/chat_setting.dart';
import 'package:company_chat_app_demo/widgets/chat_message.dart';
import 'package:company_chat_app_demo/widgets/new_message.dart';
import 'package:company_chat_app_demo/widgets/reply_new_message.dart';
import 'package:company_chat_app_demo/widgets/requests_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen.group({super.key, required this.chatRoom, required this.groupName})
      : this.userChat = null;
  ChatScreen.direct({super.key, required this.chatRoom, required this.userChat})
      : this.groupName = "";
  final ChatRoom chatRoom;
  final String groupName;
  final UserChat? userChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSearching = false;
  bool _hasBlock = false;
  bool _hasReply = false;
  bool _isMe = false;
  MessageChat _messageChat = MessageChat(
      messageId: "",
      fromId: "",
      msg: "",
      read: "",
      sent: "",
      userName: "",
      userImage: "",
      type: Type.text,
      receivers: [],
      isPin: false,
      messageReplyId: null);

  Future<void> goSettingScreen(BuildContext context) async {
    final hasBlock = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => widget.chatRoom.type!
            ? ChatSettingScreen.direct(
                chatRoom: widget.chatRoom, userChat: widget.userChat)
            : ChatSettingScreen.group(
                chatRoom: widget.chatRoom, groupName: widget.groupName),
      ),
    );
    setState(() {
      _hasBlock = hasBlock;
    });
  }

  late bool isRequests = widget.chatRoom.type! &&
      widget.chatRoom.isRequests! != ({}) &&
      widget.chatRoom.isRequests!['to'] == APIs.firebaseAuth.currentUser!.uid;
  void reLoad(bool onTap) {
    setState(() {
      isRequests = false;
    });
  }

  bool _isUploading = false;
  void _onUpload(bool upLoad) {
    setState(() {
      _isUploading = upLoad;
    });
  }

  void _onReply(bool isMe, MessageChat messageChat) {
    setState(() {
      _hasReply = true;
      _isMe = isMe;
      _messageChat = messageChat;
    });
  }

  void _cancelReply() {
    setState(() {
      _hasReply = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            widget.chatRoom.type!
                ? CircleAvatar(
                    backgroundImage: widget.userChat!.imageUrl!.isNotEmpty
                        ? NetworkImage(widget.userChat!.imageUrl!)
                        : AssetImage('assets/images/user.png') as ImageProvider,
                  )
                : CircleAvatar(
                    backgroundImage: widget.chatRoom.imageUrl!.isNotEmpty
                        ? NetworkImage(widget.chatRoom.imageUrl!)
                        : AssetImage('assets/images/group.png')
                            as ImageProvider,
                  ),
            SizedBox(
              width: 10,
            ),
            widget.chatRoom.type!
                ? Container(
                    width: 225.4,
                    child: Text(
                      widget.userChat!.username!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : Container(
                    width: 225.4,
                    child: Text(
                      widget.chatRoom.chatroomname!.isNotEmpty
                          ? widget.chatRoom.chatroomname!
                          : widget.groupName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              goSettingScreen(context);
            },
            icon: Icon(Icons.info),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessage(
              chatRoom: widget.chatRoom,
              onMessageSwipe: (messageChat, isMe) {
                _onReply(isMe, messageChat);
              },
            ),
          ),
          if (_isUploading)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: CircularProgressIndicator(),
              ),
            ),
          if (_hasReply)
            ReplyNewMessage(
              isMe: _isMe,
              messageChat: _messageChat,
              onCancel: _cancelReply,
            ),
          isRequests
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: RequestsMessage(
                      userChat: widget.userChat!,
                      chatRoomId: widget.chatRoom.chatroomid!,
                      reLoad: reLoad),
                )
              : _hasBlock
                  ? Text('Bạn đã chặn người dùng này')
                  : _hasReply
                      ? NewMessage.reply(
                          chatRoom: widget.chatRoom,
                          onUpload: (upLoad) {
                            _onUpload(upLoad);
                          },
                          messageReplyId: _messageChat.messageId)
                      : NewMessage(
                          chatRoom: widget.chatRoom,
                          onUpload: (upLoad) {
                            _onUpload(upLoad);
                          },
                        ),
        ],
      ),
    );
  }
}
