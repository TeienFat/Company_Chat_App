import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble.first({
    super.key,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.isMe
  }): isFirstInSequence = true;
  MessageBubble.second({
    super.key,
    required this.text,
    required this.isMe
  }): isFirstInSequence = false,
      userImage = null,
      userName = null;

  final bool isFirstInSequence;
  final String? userName;
  final String? userImage;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            child: CircleAvatar(
              backgroundImage: userImage!.isNotEmpty ? NetworkImage(
                userImage!,
              ) : AssetImage('assets/images/user.png') as ImageProvider,
              radius: 23,
            ),
          ),
        Container(
          margin: isMe ? null : const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) const SizedBox(height: 18),
                  if (userName != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        userName!,
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
                          : theme.colorScheme.secondary.withAlpha(200),
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe
                            ? Radius.zero
                            : const Radius.circular(12),
                        topRight: isMe
                            ? Radius.zero
                            : const Radius.circular(12),
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
                      horizontal: 12,
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe
                            ? Colors.black87
                            : theme.colorScheme.onSecondary,
                      ),
                      softWrap: true,
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