import 'dart:io';

import 'package:company_chat_app_demo/apis/apis.dart';
import 'package:company_chat_app_demo/main.dart';
import 'package:company_chat_app_demo/widgets/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  File? _selectedImage;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredRePassword = '';
  var _enteredUserName = '';
  var _isAuthenticating = false;
  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        if (_selectedImage != null) {
          final imageUrl = APIs.saveImage(
              userCredential.user!.uid, _selectedImage!, 'user_images');
          APIs.createNewUser(userCredential.user!.uid, await imageUrl,
              _enteredUserName, _enteredEmail);
        } else {
          APIs.createNewUser(
              userCredential.user!.uid, "", _enteredUserName, _enteredEmail);
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication is failed.'),
          ),
        );
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: _isLogin ? 60 : 30,
                    bottom: _isLogin ? 30 : 0,
                    right: 10),
                width: 300,
                child: Image.asset("assets/images/logoWiChat.png"),
              ),
              Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 20, left: 20, bottom: 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 14),
                              hintText: "Email",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "Vui lòng nhập địa chỉ email hợp lệ.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 14),
                                hintText: "Tên tài khoản",
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return "Vui lòng nhập vào ít nhất 4 kí tự.";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUserName = value!;
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              hintText: "Mật khẩu",
                              errorStyle: TextStyle(fontSize: 14),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Mật khẩu phải có độ dài ít nhất 6 kí tự.";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              _enteredPassword = value;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Nhập lại mật khẩu",
                                errorStyle: TextStyle(fontSize: 14),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value != _enteredPassword) {
                                  return "Nhập lại mật khẩu không đúng.";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredRePassword = value!;
                              },
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              child: Text(
                                _isLogin ? "Đăng nhập" : "Đăng kí",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kColorScheme.primary,
                                foregroundColor: kColorScheme.onPrimary,
                              ),
                              onPressed: () {
                                _submit();
                              },
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin ? "Tạo tài khoản" : "Đã có tài khoản",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
