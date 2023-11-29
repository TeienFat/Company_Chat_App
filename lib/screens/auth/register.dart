import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng kí'),
      ),
      body: Column(
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
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Your Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Your Password'),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 33, 93, 243), // background
                onPrimary: Colors.white, // foreground),
                minimumSize: Size(390, 60),
              ),
              onPressed: () {},
              child: Text('Save', style: TextStyle(fontSize: 17)),
            ),
          )
        ],
      ),
    );
  }
}
