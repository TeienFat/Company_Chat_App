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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChatroom() {
    return firestore
        .collection('chatrooms')
        .where('participants.${firebaseAuth.currentUser!.uid}',isEqualTo: true)
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

  static Future<String> getChatroomIdWhenUserHasChatRoomDirect(String currentUserid, userId) async {
    QuerySnapshot querySnapshot = await firestore.collection('chatrooms').get();

    String chatroomId = '';

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      bool isDirect = document['type'];
      if(isDirect){
        Map<String,bool> mapParticipants = Map<String,bool>.from(document['participants']);
        if(mapParticipants.containsKey(userId) && mapParticipants.containsKey(currentUserid));
        chatroomId = document['chatroomid'];
      }
    }
    return chatroomId;
  }

  static Future<ChatRoom> createDirectChatroom (String userId,String newChatroomId) async{

    String chatroomId = await getChatroomIdWhenUserHasChatRoomDirect(firebaseAuth.currentUser!.uid,userId);

    final chatroom = ChatRoom(
      chatroomid: newChatroomId,
      chatroomname: '',
      imageUrl: '',
      participants: ({firebaseAuth.currentUser!.uid: true, userId: true}),
      type: true,
      );

    if(chatroomId.isNotEmpty){
      bool hasDel = await checkCurrentUserHasDeletedChatRoom(firebaseAuth.currentUser!.uid,userId);

      if(hasDel){
        DocumentSnapshot documentSnapshot = await firestore.collection('chatrooms').doc(chatroomId).get();
        Map<String,bool> participantsMap = Map<String,bool>.from(documentSnapshot['participants']);
        participantsMap.update(firebaseAuth.currentUser!.uid, (value) => true);
        await firestore.collection('chatrooms').doc(chatroomId).update({'participants': participantsMap});
      }
    }else{
      await firestore.collection('chatrooms').doc(newChatroomId).set(chatroom.toMap());
    }
    return chatroom;
  }

  static Future<UserChat> getUserFormId(String uid) async {
    UserChat userchat;

    DocumentSnapshot docSnap =
        await firestore.collection('user').doc(uid).get();

    userchat = UserChat.fromMap(docSnap.data() as Map<String, dynamic>);

    return userchat;
  }

  static Future<bool> checkCurrentUserHasDeletedChatRoom(String currentUserId, String userId) async {
    String chatroomId = await getChatroomIdWhenUserHasChatRoomDirect(currentUserId,userId);
    DocumentSnapshot chatroomSnapshot = await firestore.collection('chatrooms').doc(chatroomId).get();
    if (chatroomSnapshot.exists) {
      Map<String,bool> mapParticipants = Map<String,bool>.from(chatroomSnapshot['participants']);
      bool inChatRoom = mapParticipants[firebaseAuth.currentUser!.uid]!;
      if (!inChatRoom) {
        return true;
      } else return false;
    } else return false;
  }
  static _getLastWordOfName(String name) {
    List<String> words = name.split(" ");
    return words[words.length - 1];
  }

  // static Future<String> getChatRoomName(ChatRoom chatRoom) async {
  //   List<String> listId = chatRoom.participants!;
  //   int numOfParticipants = listId.length;
  //   listId = listId.sublist(1, 3);
  //   String name = "";
  //   for (var i = 0; i <= 1; i++) {
  //     UserChat userchat;

  //     DocumentSnapshot docSnap =
  //         await firestore.collection('user').doc(listId[i]).get();

  //     userchat = UserChat.fromMap(docSnap.data() as Map<String, dynamic>);
  //     if (i == 0) {
  //       name = name + _getLastWordOfName(userchat.username!) + ", ";
  //     } else {
  //       name = name + _getLastWordOfName(userchat.username!);
  //     }
  //   }
  //   return name + " và " + (numOfParticipants - 3).toString() + " người khác";
  // }

  // static Future<ChatRoom> createGroupChatroom(List<String> participantsId,
  //     String chatRoomId, String chatRoomName) async {
  //   participantsId.insert(0, firebaseAuth.currentUser!.uid);
  //   final chatroom = ChatRoom(
  //       chatroomid: chatRoomId,
  //       chatroomname: chatRoomName,
  //       imageUrl: '',
  //       participants: participantsId,
  //       type: false);
  //   await firestore
  //       .collection('chatrooms')
  //       .doc(chatRoomId)
  //       .set(chatroom.toMap());
  //   return chatroom;
  // }

  // static Future<void> leaveTheGroupChat(
  //     ChatRoom chatRoom, String userId) async {
  //   List<String> participants = chatRoom.participants!;
  //   participants.removeWhere((element) => element == userId);
  //   return await firestore
  //       .collection('chatrooms')
  //       .doc(chatRoom.chatroomid)
  //       .update({'participants': participants});
  // }
}
