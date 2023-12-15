import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/chatroom_card.dart';
import 'package:company_chat_app_demo/widgets/chatroom_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  bool isSearching = false;

  List<ChatRoom> _listChatroom = [];
  List<ChatRoom> _searchListChatRoom = [];

  Future<void> _runFilter(String enteredKeyword) async {
    var mapName = await APIs.getNameInfo();
    List<String> nameList = mapName.values.toList();
    List<String> _searchListId = [];
    _searchListChatRoom.clear();
    for (var name in nameList) {
      if (name.toLowerCase().contains(enteredKeyword.toLowerCase())) {
        var key = mapName.keys.firstWhere((value) => mapName[value] == name);
        _searchListId.add(key);
      }
    }
    for (var room in _listChatroom) {
      bool isParticipant = _searchListId
          .any((element) => room.participants!.keys.contains(element));

      if (_searchListId.contains(room.chatroomid!) || isParticipant) {
        _searchListChatRoom.add(room);
      }
    }
    setState(() {
      isSearching = true;
      _searchListChatRoom;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('pause')) APIs.updateStatus(false);
      if (message.toString().contains('resume')) APIs.updateStatus(true);
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          searchBar(_runFilter),
          StreamBuilder(
            stream: APIs.getAllChatroom(),
            builder: (ctx, chatroomSnapshot) {
              if (chatroomSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  heightFactor: 10,
                  child: CircularProgressIndicator(),
                );
              }
              if (!chatroomSnapshot.hasData ||
                  chatroomSnapshot.data!.docs.isEmpty) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Không tìm thấy đoạn chat nào',
                  ),
                );
              }
              if (chatroomSnapshot.hasError) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Có gì đó sai sai',
                  ),
                );
              }
              final data = chatroomSnapshot.data!.docs;
              _listChatroom = data
                  .map<ChatRoom>((e) => ChatRoom.fromMap(e.data()))
                  .toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: isSearching
                      ? (_searchListChatRoom.isEmpty
                          ? 1
                          : _searchListChatRoom.length)
                      : _listChatroom.length,
                  itemBuilder: (ctx, index) {
                    if (isSearching) {
                      if (_searchListChatRoom.isEmpty)
                        return Center(
                            child: Text('Không tìm thấy đoạn chat nào'));
                      bool typeRoom = _searchListChatRoom[index].type!;
                      List<String> userIdLisst = _searchListChatRoom[index]
                          .participants!
                          .keys
                          .toList();
                      String userid = userIdLisst.elementAt(0);
                      if (userid == APIs.firebaseAuth.currentUser!.uid)
                        userid = userIdLisst.elementAt(1);
                      if (typeRoom) {
                        return StreamBuilder(
                          stream: APIs.getInfoUser(userid.toString()),
                          builder: (ctx, usersnapshot) {
                            if(usersnapshot.hasData){
                              final data = usersnapshot.data!.docs;
                            final list = data
                                .map((e) => UserChat.fromMap(e.data()))
                                .toList();
                            return ChatRoomCard(
                                  chatRoom: _searchListChatRoom[index],
                                  userchat: list[0]);
                            } else return Container();
                          },
                        );
                      }
                      return FutureBuilder(
                          future:
                              APIs.getChatRoomName(_searchListChatRoom[index]),
                          builder: (ctx, chatroomnamesnapshot) {
                            if (chatroomnamesnapshot.connectionState ==
                                ConnectionState.done) {
                              String groupName = chatroomnamesnapshot.data!;
                              return ChatRoomGroupChat(
                                chatRoom: _searchListChatRoom[index],
                                groupName: groupName,
                              );
                            } else
                              return Container();
                          });
                    } else {
                      bool typeRoom = _listChatroom[index].type!;
                      List<String> userIdLisst =
                          _listChatroom[index].participants!.keys.toList();
                      String userid = userIdLisst.elementAt(0);
                      if (userid == APIs.firebaseAuth.currentUser!.uid)
                        userid = userIdLisst.elementAt(1);
                      if (typeRoom) {
                        return StreamBuilder(
                          stream: APIs.getInfoUser(userid.toString()),
                          builder: (ctx, usersnapshot) {
                            if(usersnapshot.hasData){
                              final data = usersnapshot.data!.docs;
                            final list = data
                                .map((e) => UserChat.fromMap(e.data()))
                                .toList();
                            return ChatRoomCard(
                                  chatRoom: _listChatroom[index],
                                  userchat: list[0]);
                            } else return Container();
                          },
                        );
                      }
                      return FutureBuilder(
                          future: APIs.getChatRoomName(_listChatroom[index]),
                          builder: (ctx, chatroomnamesnapshot) {
                            if (chatroomnamesnapshot.connectionState ==
                                ConnectionState.done) {
                              String groupName = chatroomnamesnapshot.data!;
                              return ChatRoomGroupChat(
                                chatRoom: _listChatroom[index],
                                groupName: groupName,
                              );
                            } else
                              return Container();
                          });
                    }
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
