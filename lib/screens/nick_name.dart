import 'package:company_chat_app_demo/main.dart';
import 'package:flutter/material.dart';

class NickName extends StatefulWidget {
  const NickName({super.key});

  @override
  State<NickName> createState() => _NickNameState();
}

class _NickNameState extends State<NickName> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nickName = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Đổi tên gợi nhớ',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: nickName,
              decoration: InputDecoration(
                hintText: 'Biệt danh',
              ),
              maxLength: 40,
            ),
            SizedBox(
              height: 610,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Lưu',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 50),
                  primary: kColorScheme.primary,
                  onPrimary: kColorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }
}
