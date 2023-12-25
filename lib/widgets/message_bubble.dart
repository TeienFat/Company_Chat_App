import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/widgets/bubble_image.dart';
import 'package:company_chat_app_demo/widgets/bubble_video.dart';
import 'package:company_chat_app_demo/widgets/menu_option_chatscreen.dart';
import 'package:company_chat_app_demo/widgets/reply_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble.first(
      {super.key,
      required this.message,
      required this.chatRoomId,
      required this.isMe,
      required this.typeChat,
      required this.isLastInSequence,
      required this.isLastMessage,
      required this.onSwipe,
      required this.onTapReply,
      required this.isScrollTo})
      : isFirstInSequence = true;
  MessageBubble.second(
      {super.key,
      required this.chatRoomId,
      required this.message,
      required this.isMe,
      required this.typeChat,
      required this.isLastInSequence,
      required this.isLastMessage,
      required this.onSwipe,
      required this.onTapReply,
      required this.isScrollTo})
      : isFirstInSequence = false;
  final MessageChat message;
  final String chatRoomId;
  final bool typeChat;
  final bool isMe;
  final bool isFirstInSequence;
  final bool isLastInSequence;
  final bool isLastMessage;
  final Function(MessageChat messageChat, bool isMe) onSwipe;
  final Function(String messageIdToScroll) onTapReply;
  final bool isScrollTo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? colorMess;
    if (!isMe && message.read!.isEmpty) {
      APIs.updateMessageReadStatus(chatRoomId, message.messageId!);
    }
    if (isMe && isScrollTo) {}
    return Stack(
      children: [
        if (message.userImage != null && isFirstInSequence)
          Positioned(
            top: 15,
            child: CircleAvatar(
              backgroundImage: message.userImage!.isNotEmpty
                  ? NetworkImage(
                      message.userImage!,
                    )
                  : AssetImage('assets/images/user.png') as ImageProvider,
              radius: 18,
            ),
          ),
        GestureDetector(
          onLongPress: () async {
            final bool isPin =
                await APIs.checkPinMessage(message.messageId!, chatRoomId);
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => MenuChatScreen(
                chatroomId: chatRoomId,
                messageId: message.messageId!,
                isPin: isPin,
              ),
            );
          },
          child: Container(
            margin: isMe ? null : const EdgeInsets.symmetric(horizontal: 45),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (isFirstInSequence) const SizedBox(height: 30),
                    if (message.userName != null && !typeChat)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        child: Text(
                          message.userName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    Stack(
                      children: [
                        SwipeTo(
                          swipeSensitivity: 10,
                          animationDuration: Duration(milliseconds: 200),
                          offsetDx: 0.8,
                          leftSwipeWidget: Container(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.reply,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          rightSwipeWidget: Container(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.reply,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onLeftSwipe: isMe
                              ? (details) {
                                  onSwipe(message, isMe);
                                }
                              : null,
                          onRightSwipe: isMe
                              ? null
                              : (details) {
                                  onSwipe(message, isMe);
                                },
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (message.messageReplyId != null)
                                InkWell(
                                  onTap: () {
                                    onTapReply(message.messageReplyId!);
                                  },
                                  child: ReplyBubble(
                                      chatRoomId: chatRoomId,
                                      messageReplyId: message.messageReplyId!,
                                      messageSent: message,
                                      isMe: isMe),
                                ),
                              Container(
                                decoration: message.type! == Type.text
                                    ? BoxDecoration(
                                        color: isMe && isScrollTo
                                            ? Colors.grey
                                            : isMe
                                                ? Colors.grey[300]
                                                : isScrollTo
                                                    ? Colors.red[200]
                                                    : theme.colorScheme
                                                        .primaryContainer,
                                        borderRadius: BorderRadius.only(
                                          topLeft: !isMe
                                              ? Radius.zero
                                              : const Radius.circular(12),
                                          topRight: isMe
                                              ? Radius.zero
                                              : const Radius.circular(12),
                                          bottomLeft: const Radius.circular(12),
                                          bottomRight:
                                              const Radius.circular(12),
                                        ),
                                      )
                                    : null,
                                constraints:
                                    const BoxConstraints(maxWidth: 295),
                                padding: message.type! == Type.text
                                    ? const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 14,
                                      )
                                    : null,
                                margin: message.messageReplyId == null
                                    ? const EdgeInsets.symmetric(
                                        vertical: 4,
                                      )
                                    : EdgeInsets.only(bottom: 4),
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                                  children: [
                                    message.type! == Type.text
                                        ? Text(
                                            message.msg!,
                                            style: TextStyle(
                                              height: 1.3,
                                              color: isMe
                                                  ? Colors.black87
                                                  : theme.colorScheme
                                                      .onPrimaryContainer,
                                            ),
                                            softWrap: true,
                                          )
                                        : message.type! == Type.image
                                            ? ImageBubble(
                                                imageUrl: message.msg!,
                                                isMe: isMe)
                                            : message.type! == Type.video
                                                ? VideoBubble(
                                                    videoUrl: message.msg!,
                                                    isMe: isMe,
                                                  )
                                                : SizedBox(),
                                    if (isLastInSequence)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (isLastInSequence)
                                      Text(
                                        MyDateUtil.getFormattedTime(
                                            context: context,
                                            time: message.sent.toString()),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isMe
                                              ? Colors.black87
                                              : theme.colorScheme
                                                  .onPrimaryContainer,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (message.isPin!)
                          isMe
                              ? Positioned.fill(
                                  left: -3,
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Icon(
                                        Icons.push_pin,
                                        size: 16,
                                        color: Colors.red,
                                      )))
                              : Positioned.fill(
                                  right: -3,
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.push_pin,
                                        size: 16,
                                        color: Colors.red,
                                      )))
                      ],
                    ),
                    if (isMe && isLastMessage && message.read!.isNotEmpty)
                      Icon(
                        Icons.done_all_rounded,
                        color: Colors.green,
                      ),
                    if (isMe &&
                        isLastMessage &&
                        isLastInSequence &&
                        message.read!.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3.0),
                          child: Text(
                            'Đã gửi',
                            style: TextStyle(
                              fontSize: 12,
                              color: isMe
                                  ? Colors.white
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
