import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  bool _isTyping = true;
  TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    APIs.sendMessage(widget.chatRoom, enteredMessage.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _isTyping
              ? IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      _isTyping = false;
                    });
                  },
                  icon: Icon(Icons.add),
                )
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.image,
                          color: kColorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.file_present,
                          color: kColorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.mic_none,
                          color: kColorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: TextField(
              maxLines: null,
              maxLength: 1000,
              controller: _messageController,
              style: TextStyle(fontSize: 18),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              onTap: () {
                setState(() {
                  _isTyping = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  _isTyping = true;
                });
              },
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                filled: true,
                counterText: '',
                fillColor: kColorScheme.surfaceVariant,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: "Aa",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kColorScheme.primary, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kColorScheme.primary, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
