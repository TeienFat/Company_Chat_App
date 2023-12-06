import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, required this.deleteUser});
  final UserChat user;
  final void Function(UserChat user) deleteUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 95,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: user.imageUrl!.isNotEmpty
                              ? NetworkImage(user.imageUrl!)
                              : AssetImage('assets/images/user.png')
                                  as ImageProvider),
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      deleteUser(user);
                    },
                    child: Icon(
                      Icons.cancel,
                      size: 20,
                      color: kColorScheme.primary,
                    ),
                  ),
                  // width: 17,
                  // height: 17,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 234, 234),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Text(
            user.username!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
