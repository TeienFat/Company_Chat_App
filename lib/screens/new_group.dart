import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/user_avatar.dart';
import 'package:company_chat_app_demo/widgets/user_card_checkbox.dart';
import 'package:flutter/material.dart';

class NewGroupChat extends StatefulWidget {
  const NewGroupChat({super.key});

  @override
  State<NewGroupChat> createState() => _NewGroupChatState();
}

class _NewGroupChatState extends State<NewGroupChat> {
  List<UserChat> _list = [];
  List<UserChat> _searchList = [];
  List<UserChat> _listUser = [
    // UserChat(
    //   id: "TmNKDtjggqbJcVuSwG3gQQcwnKy2",
    //   imageUrl:
    //       "https://firebasestorage.googleapis.com/v0/b/companychatapp-9fa5b.appspot.com/o/user_images%2FTmNKDtjggqbJcVuSwG3gQQcwnKy2.jpg?alt=media&token=c4760f80-c074-4c04-bbb7-6bab25d1f0ce",
    //   username: "Thi Boi",
    //   isOnline: false,
    //   email: "thiboi@gmail.com",
    // ),
  ];
  final _groupNameController = TextEditingController();
  bool _canCreate = false;
  String tb = "";
  void _runFilter(String _enteredKeyword) {
    _searchList.clear();
    for (var user in _list) {
      if (user.username!
          .toLowerCase()
          .contains(_enteredKeyword.toLowerCase())) {
        _searchList.add(user);
      }
    }
    setState(() {
      _searchList;
    });
  }

  void _addUser(UserChat user, bool isAdd) {
    setState(() {
      if (isAdd) {
        _listUser.add(user);
      } else {
        _listUser.removeWhere(
          (element) => element.id == user.id,
        );
      }
      if (_listUser.length > 1) {
        _canCreate = true;
      } else {
        _canCreate = false;
      }
    });
  }

  void _deleteUser(UserChat user) {
    setState(
      () {
        _listUser.remove(user);
        if (_listUser.length < 2) {
          _canCreate = false;
        }
      },
    );
  }

  bool _checkContains(UserChat userChat) {
    for (UserChat user in _listUser) {
      if (user.id == userChat.id) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Hủy",
                        style: TextStyle(fontSize: 20, color: Colors.blue[400]),
                      ),
                    ),
                    Text(
                      "Nhóm mới",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: _canCreate
                          ? () {
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        "Tạo",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: _groupNameController,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "Tên nhóm (không bắt buộc)",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                searchBar(_runFilter),
                if (_listUser.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 95,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        List<UserChat> _listUserReverse =
                            _listUser.reversed.toList();
                        return Row(
                          children: [
                            UserAvatar(
                              user: _listUser.length < 6
                                  ? _listUser[index]
                                  : _listUserReverse[index],
                              deleteUser: _deleteUser,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        );
                      },
                      itemCount: _listUser.length,
                      reverse: _listUser.length > 5 ? true : false,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    "Gợi ý",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: APIs.getAllUser(),
                  builder: (ctx, userSnapshot) {
                    // if (userSnapshot.connectionState ==
                    //     ConnectionState.waiting) {
                    //   return const Center(
                    //     child: CircularProgressIndicator()
                    //   );
                    // }
                    if (!userSnapshot.hasData ||
                        userSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No user found.',
                        ),
                      );
                    }
                    if (userSnapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something went wrong...',
                        ),
                      );
                    }
                    final data = userSnapshot.data!.docs;
                    _list =
                        data.map((e) => UserChat.fromMap(e.data())).toList();
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchList.isEmpty
                            ? _list.length
                            : _searchList.length,
                        itemBuilder: (ctx, index) {
                          UserChat userChat = _searchList.isEmpty
                              ? _list[index]
                              : _searchList[index];
                          return Column(
                            children: [
                              UserCardCheckbox(
                                user: userChat,
                                onTap: _addUser,
                                isNotChecked:
                                    _checkContains(userChat) ? true : false,
                              ),
                              const Divider(
                                height: 3,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
