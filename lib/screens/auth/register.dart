import 'package:company_chat_app_demo/main.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String gmail = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đăng Kí',
          style: TextStyle(color: kColorScheme.onPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ElevatedButton(onPressed: (){} , child: Icon(Icons.)),
            SizedBox(
              height: 60,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(20, 158, 158, 158),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Icon(
                Icons.person_add_alt_1,
                size: 70.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Your Email'),
                onChanged: (text) {
                  gmail = text;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Enter Your Password'),
                onChanged: (text) {
                  password = text;
                },
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kColorScheme.primary,
                  onPrimary: kColorScheme.onPrimary,
                  minimumSize: Size(390, 60),
                ),
                onPressed: () {
                  setState(() {
                    Text('$gmail');
                    Text('$password');
                  });
                },
                child: Text('Save', style: TextStyle(fontSize: 17)),
              ),
            ),
            Text('$gmail'),
            Text('$password'),
          ],
        ),
      ),
    );
  }
}
