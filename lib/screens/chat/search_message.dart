import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:flutter/material.dart';

class SearchMessageScreen extends StatefulWidget {
  SearchMessageScreen({super.key, required this.chatroom});
  ChatRoom chatroom;

  @override
  State<SearchMessageScreen> createState() => _SearchMessageScreenState();
}

class _SearchMessageScreenState extends State<SearchMessageScreen> {
  List<Message> listMessage = [];

  void searchMessage(String _enteredKeyword) async{
    listMessage = await APIs.getSearchMessage(_enteredKeyword, widget.chatroom.chatroomid!);
    setState(() {
      listMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(247, 247, 252, 1),
          hintText: 'Tìm kiếm trong cuộc trò chuyện',
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          ),
          onSubmitted: (value){
            searchMessage(value);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
            child: Text(listMessage.length.toString() + " tin nhắn trùng khớp",style: TextStyle(color: const Color.fromARGB(255, 169, 169, 169),fontWeight: FontWeight.w500),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listMessage.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: listMessage[index].userImage!.isNotEmpty
                          ? NetworkImage(listMessage[index].userImage!)
                          : AssetImage('assets/images/group.png') as ImageProvider,
                      ),
                      SizedBox(width: 12,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listMessage[index].userName!,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                          Text(listMessage[index].msg!,style: TextStyle(color: const Color.fromARGB(255, 93, 93, 93)),)
                        ],
                      )
                    ],
                  ),
                );
            }),
          ),
        ],
      ),
    );
  }
}