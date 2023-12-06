import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('user')
        .where('id', isNotEqualTo: firebaseAuth.currentUser!.uid)
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
    final user = UserChat(
        id: userId,
        imageUrl: imageUrl,
        username: userName,
        isOnline: false,
        email: email);
    return await firestore.collection('user').doc(userId).set(user.toMap());
  }

  static Future<bool> checkHasChatRoom(String userid) async {
    QuerySnapshot querySnapshot = await firestore.collection('chatrooms').get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      List<String> listParticipants =
          List<String>.from(document['participants']);
      if (listParticipants.contains(firebaseAuth.currentUser!.uid) &&
          listParticipants.contains(userid)) {
        return true;
      }
    }
    return false;
  }

  static Future<void> createDirectChatroom(
      String userId, String chatRoomId) async {
    final chatroom = ChatRoom(
        chatroomid: chatRoomId,
        chatroomname: '',
        imageUrl: '',
        participants: [firebaseAuth.currentUser!.uid, userId],
        type: true);
    return await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .set(chatroom.toMap());
  }

  static Future<void> createGroupChatroom(
      String userId, String chatRoomId) async {
    final chatroom = ChatRoom(
        chatroomid: chatRoomId,
        chatroomname: '',
        imageUrl: '',
        participants: [firebaseAuth.currentUser!.uid, userId],
        type: false);
    return await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .set(chatroom.toMap());
  }
}
