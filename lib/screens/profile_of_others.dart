import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/screens/nick_name.dart';
import 'package:flutter/material.dart';

class ProfileOfOthersScreen extends StatefulWidget {
  const ProfileOfOthersScreen({super.key});

  @override
  State<ProfileOfOthersScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileOfOthersScreen> {
  void nickNameUser() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => NickName(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(20)),
            Image.asset(
              'assets/images/user.png',
              height: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Tiến Ú',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wechat,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Nhắn tin',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 40),
                    primary: kColorScheme.primary,
                    onPrimary: kColorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  onPressed: nickNameUser,
                  icon: Icon(Icons.border_color_outlined),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Thông tin cá nhân',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Điện thoại : 0935767192',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Giới tính : Nam',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    'Ngày tháng năm sinh : 01 tháng 09 năm 2002',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Địa chỉ : Nha Trang',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Bạn có chắc chắn muốn chặn người này ?'),
                  content: const Text(
                      'Bạn sẽ không nhận được bất kỳ tin nhắn nào từ người này nữa'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Chặn",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(400, 50),
                primary: kColorScheme.primary,
                onPrimary: kColorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
