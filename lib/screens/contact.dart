import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_chat_app_demo/helper/helper.dart';
// import 'package:company_chat_app_demo/models/user.dart';
import 'package:company_chat_app_demo/widgets/user_card.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
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
                final loadedUser = userSnapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: loadedUser.length,
                    itemBuilder: (ctx, index) {
                      final user = loadedUser[index].data();
                      return Column(
                        children: [
                          UserCard(
                            username: user['username'],
                            isOnline: user['isOnline'],
                            userImage: user['imageUrl'],
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
