import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble.first({
    super.key,
    required this.message,
    required this.chatRoomId,
    required this.isMe,
    required this.typeChat,
    required this.isLastInSequence,
    required this.isLastMessage,
  }) : isFirstInSequence = true;
  MessageBubble.second({
    super.key,
    required this.chatRoomId,
    required this.message,
    required this.isMe,
    required this.typeChat,
    required this.isLastInSequence,
    required this.isLastMessage,
  }) : isFirstInSequence = false;
  final Message message;
  final String chatRoomId;
  final bool typeChat;
  final bool isMe;
  final bool isFirstInSequence;
  final bool isLastInSequence;
  final bool isLastMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isMe && message.read!.isEmpty) {
      APIs.updateMessageReadStatus(chatRoomId, message.messageId!);
    }
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
        Container(
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
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.grey[300]
                          : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft:
                            !isMe ? Radius.zero : const Radius.circular(12),
                        topRight:
                            isMe ? Radius.zero : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.msg!,
                          style: TextStyle(
                            height: 1.3,
                            color: isMe
                                ? Colors.black87
                                : theme.colorScheme.onPrimaryContainer,
                          ),
                          softWrap: true,
                        ),
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
                              fontSize: 10,
                              color: isMe
                                  ? Colors.black87
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                      ],
                    ),
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
                    Text(
                      'Đã gửi',
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe
                            ? Colors.black87
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
