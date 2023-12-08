import 'package:flutter/material.dart';

class MenuOpTionChatRoom extends StatelessWidget {
  const MenuOpTionChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        return SizedBox(
          height: constraints.maxHeight/2,
          child: Column(
            children: [
              InkWell(
                onTap: (){},
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
              InkWell(
                onTap: (){},
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
              InkWell(
                onTap: (){},
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
              InkWell(
                onTap: (){},
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
              InkWell(
                onTap: (){},
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
              InkWell(
                onTap: (){},
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