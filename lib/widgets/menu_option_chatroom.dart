import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:flutter/material.dart';

class MenuOpTionChatRoom extends StatelessWidget {
  const MenuOpTionChatRoom({super.key, required this.chatRoomId});

  final String chatRoomId;

  @override
  Widget build(BuildContext context) {



    return LayoutBuilder(
      builder: (context,constraints){
        return SizedBox(
          height: constraints.maxHeight/2,
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  APIs.deleteChatRoom(chatRoomId);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever,size: 30,),
                      SizedBox(width: 16,),
                      Text('Xoá',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}