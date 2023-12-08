import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 700,
          child: Center(
            child: Text('Say something!'),
          ),
        ),
      ],
    );
  }
}
