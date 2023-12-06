import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:flutter/material.dart';

class UserCardCheckbox extends StatefulWidget {
  const UserCardCheckbox({
    super.key,
    required this.user,
    required this.onTap,
    required this.isNotChecked,
  });

  final UserChat user;
  final void Function(UserChat user, bool isChecked) onTap;
  final bool isNotChecked;

  @override
  State<UserCardCheckbox> createState() => _UserCardCheckboxState();
}

class _UserCardCheckboxState extends State<UserCardCheckbox> {
  @override
  Widget build(BuildContext context) {
    bool _isChecked = widget.isNotChecked;
    return InkWell(
      onTap: () {
        setState(
          () {
            _isChecked = !_isChecked;
            widget.onTap(widget.user, _isChecked);
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 16),
        child: Row(
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
                            image: widget.user.imageUrl!.isNotEmpty
                                ? NetworkImage(widget.user.imageUrl!)
                                : AssetImage('assets/images/user.png')
                                    as ImageProvider),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                if (widget.user.isOnline!)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(44, 192, 105, 1),
                          shape: BoxShape.circle,
                          border: Border.symmetric(
                              horizontal:
                                  BorderSide(width: 2, color: Colors.white),
                              vertical:
                                  BorderSide(width: 2, color: Colors.white))),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.username!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                widget.user.isOnline!
                    ? const Text(
                        'Online',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(173, 181, 189, 1)),
                      )
                    : const Text(
                        'Offline',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(173, 181, 189, 1)),
                      ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _isChecked ? kColorScheme.primary : null,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: kColorScheme.primary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: _isChecked
                      ? Icon(
                          Icons.check,
                          size: 18.0,
                          color: Color.fromARGB(255, 244, 234, 234),
                        )
                      : Icon(
                          null,
                          size: 18.0,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
