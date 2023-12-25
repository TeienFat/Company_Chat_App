import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/widgets/bubble_image.dart';
import 'package:company_chat_app_demo/widgets/bubble_video.dart';
import 'package:flutter/material.dart';

class ReplyBubble extends StatelessWidget {
  const ReplyBubble({
    super.key,
    required this.chatRoomId,
    required this.messageReplyId,
    required this.messageSent,
    required this.isMe,
  });
  final String chatRoomId;
  final String messageReplyId;
  final MessageChat messageSent;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    String? titleReply;
    return FutureBuilder(
        future: APIs.getMessageFromId(chatRoomId, messageReplyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            MessageChat messageReply = snapshot.data!;
            if (messageSent.fromId == messageReply.fromId && isMe) {
              titleReply = 'Bạn đã trả lời chính mình';
            }
            if (messageSent.fromId == messageReply.fromId && !isMe) {
              titleReply = messageReply.userName! + ' đã trả lời chính mình';
            }
            if (messageSent.fromId != messageReply.fromId && isMe) {
              titleReply = 'Bạn đã trả lời ' + messageReply.userName!;
            }
            if (messageSent.fromId != messageReply.fromId && !isMe) {
              titleReply = messageSent.userName! + ' đã trả lời bạn';
            }
            return Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: isMe ? 0 : 10, right: isMe ? 10 : 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        titleReply!,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: messageReply.type! == Type.text
                      ? BoxDecoration(
                          color: Color.fromARGB(10, 0, 0, 0),
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                !isMe ? Radius.zero : const Radius.circular(12),
                            bottomRight:
                                isMe ? Radius.zero : const Radius.circular(12),
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                          ),
                        )
                      : null,
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                  ),
                  padding: messageReply.type! == Type.text
                      ? const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      messageReply.type! == Type.text
                          ? Text(
                              messageReply.msg!,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.3,
                                color: Colors.black87,
                              ),
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            )
                          : messageReply.type! == Type.image
                              ? ImageBubble(
                                  imageUrl: messageReply.msg!, isMe: isMe)
                              : messageReply.type! == Type.video
                                  ? VideoBubble(
                                      videoUrl: messageReply.msg!,
                                      isMe: isMe,
                                    )
                                  : SizedBox(),
                    ],
                  ),
                ),
              ],
            );
          } else
            return SizedBox();
        });
  }
}
