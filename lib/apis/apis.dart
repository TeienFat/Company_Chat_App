import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_chat_app_demo/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('user')
        .where('id', isNotEqualTo: '111')
        .snapshots();
  }

  static Future<String> saveImage(
      String imageName, File imageFile, String path) async {
    final storageRef =
        await fireStorage.ref().child(path).child('${imageName}.jpg');
    await storageRef.putFile(
        imageFile, SettableMetadata(contentType: 'image/jpg'));
    return await storageRef.getDownloadURL();
  }

  static Future<void> createNewUser(
      String userId, String imageUrl, String userName, String email) async {
    final user = User(
        id: userId,
        imageUrl: imageUrl,
        username: userName,
        isOnline: false,
        email: email);
    return await firestore.collection('user').doc(userId).set(user.toMap());
  }
}
