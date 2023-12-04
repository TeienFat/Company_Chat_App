import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:company_chat_app_demo/widgets/user_card.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool isSearching = false;
  List<UserChat> _list = [];
  List<UserChat> _searchList = [];

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
      isSearching = true;
      _searchList;
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
              stream: APIs.getAllUser(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    heightFactor: 10,
                    child: CircularProgressIndicator(),
                  );
                }
                if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
                  return const Center(
                    heightFactor: 10,
                    child: Text(
                      'No user found.',
                    ),
                  );
                }
                if (userSnapshot.hasError) {
                  return const Center(
                    heightFactor: 10,
                    child: Text(
                      'Something went wrong...',
                    ),
                  );
                }
                final data = userSnapshot.data!.docs;
                _list = data.map((e) => UserChat.fromMap(e.data())).toList();
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isSearching
                        ? (_searchList.isEmpty 
                          ? 1 
                          : _searchList.length)
                        : _list.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          isSearching
                              ? (_searchList.isEmpty
                                ? Text('No user found')
                                : UserCard(user: _searchList[index]))
                              : UserCard(user: _list[index])
                        ],
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
