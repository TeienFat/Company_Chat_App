import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:flutter/material.dart';

class MenuOpTionChatRoom extends StatelessWidget {
  const MenuOpTionChatRoom({super.key, required this.chatRoomId});

  final String chatRoomId;

  Future<void> showDiaLog(BuildContext ctx) async{
    await showDialog(context: ctx, builder: (ctx) => 
      AlertDialog(
      title: Text("Xoá đoạn chat này?"),
      content: Container(
        child: Text("Bạn không thể hoàn tác sau khi xoá cuộc trò chuyện này."),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Huỷ")
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              APIs.deleteChatRoom(chatRoomId);
            },
            child: Text("Xoá")
        )
      ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        return SizedBox(
          height: constraints.maxHeight/2,
          child: Column(
            children: [
              InkWell(
                onTap: () async{
                  Navigator.pop(context);
                  await showDiaLog(context);
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