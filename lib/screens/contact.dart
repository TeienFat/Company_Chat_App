import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
// import 'package:company_chat_app_demo/models/user.dart';
import 'package:company_chat_app_demo/widgets/user_card.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<User> _list = [];

  void _runFilter(){

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
                    child: CircularProgressIndicator(),
                  );
                }
                if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
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
                _list = data.map((e) => User.fromMap(e.data())).toList();
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _list.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          UserCard(
                            user: _list[index],
                          ),
                          const Divider(height: 3,)
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
