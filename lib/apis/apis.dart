import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

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
        .where('participants.${firebaseAuth.currentUser!.uid}', isEqualTo: true)
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

  static Future<String> getChatroomIdWhenUserHasChatRoomDirect(
      String currentUserid, String userId) async {
    QuerySnapshot querySnapshot = await firestore.collection('chatrooms').get();

    String chatroomId = '';

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      bool isDirect = document['type'];
      if (isDirect) {
        Map<String, bool> mapParticipants =
            Map<String, bool>.from(document['participants']);
        if (mapParticipants.containsKey(userId) &&
            mapParticipants.containsKey(currentUserid))
          chatroomId = document['chatroomid'];
      }
    }
    return chatroomId;
  }

  static Future<ChatRoom> createDirectChatroom(
      String userId, String newChatroomId) async {
    String chatroomId = await getChatroomIdWhenUserHasChatRoomDirect(
        firebaseAuth.currentUser!.uid, userId);

    ChatRoom chatroom;

    if (chatroomId.isNotEmpty) {
      DocumentSnapshot docSnap =
          await firestore.collection('chatrooms').doc(chatroomId).get();

      chatroom = ChatRoom.fromMap(docSnap.data() as Map<String, dynamic>);

      bool hasDel = await checkCurrentUserHasDeletedChatRoom(
          firebaseAuth.currentUser!.uid, userId);

      if (hasDel) {
        DocumentSnapshot documentSnapshot =
            await firestore.collection('chatrooms').doc(chatroomId).get();
        Map<String, bool> participantsMap =
            Map<String, bool>.from(documentSnapshot['participants']);
        participantsMap.update(firebaseAuth.currentUser!.uid, (value) => false);
        await firestore
            .collection('chatrooms')
            .doc(chatroomId)
            .update({'participants': participantsMap});
      }
    } else {
      chatroom = ChatRoom(
        chatroomid: newChatroomId,
        chatroomname: '',
        imageUrl: '',
        participants: ({firebaseAuth.currentUser!.uid: false, userId: false}),
        type: true,
        isRequests: ({'from': firebaseAuth.currentUser!.uid, 'to': userId}),
      );
      await firestore
          .collection('chatrooms')
          .doc(newChatroomId)
          .set(chatroom.toMap());
    }
    return chatroom;
  }

  static Future<ChatRoom> getChatRoomFromId(String chatRoomId) async {
    ChatRoom chatRoom;

    DocumentSnapshot docSnap =
        await firestore.collection('chatrooms').doc(chatRoomId).get();

    chatRoom = ChatRoom.fromMap(docSnap.data() as Map<String, dynamic>);

    return chatRoom;
  }

  static Future<UserChat> getUserFormId(String uid) async {
    UserChat userchat;

    DocumentSnapshot docSnap =
        await firestore.collection('user').doc(uid).get();

    userchat = UserChat.fromMap(docSnap.data() as Map<String, dynamic>);

    return userchat;
  }

  static Future<bool> checkCurrentUserHasDeletedChatRoom(
      String currentUserId, String userId) async {
    String chatroomId =
        await getChatroomIdWhenUserHasChatRoomDirect(currentUserId, userId);
    DocumentSnapshot chatroomSnapshot =
        await firestore.collection('chatrooms').doc(chatroomId).get();
    if (chatroomSnapshot.exists) {
      Map<String, bool> mapParticipants =
          Map<String, bool>.from(chatroomSnapshot['participants']);
      bool inChatRoom = mapParticipants[firebaseAuth.currentUser!.uid]!;
      if (!inChatRoom) {
        return true;
      } else
        return false;
    } else
      return false;
  }

  static getLastWordOfName(String name) {
    List<String> words = name.split(" ");
    return words[words.length - 1];
  }

  static Future<void> deleteChatRoom(String chatroomId) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('chatrooms').doc(chatroomId).get();
    Map<String, bool> participantsMap =
        Map<String, bool>.from(documentSnapshot['participants']);

    print(participantsMap.values);

    participantsMap.update(firebaseAuth.currentUser!.uid, (value) => false);

    print(participantsMap.values);

    if (participantsMap.values.every((values) => values == false)) {
      await firestore.collection('chatrooms').doc(chatroomId).delete();
      print('đã xoá');
    } else {
      await firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .update({'participants': participantsMap});
      print('chưa xoá được');
    }
  }

  static Future<String> getChatRoomName(ChatRoom chatRoom) async {
    Map<String, bool> participants = chatRoom.participants!;
    List<String> listId = participants.keys.toList();
    int numOfParticipants = listId.length;
    listId = listId.sublist(1, 3);
    String name = "";
    for (var i = 0; i <= 1; i++) {
      UserChat userchat;

      DocumentSnapshot docSnap =
          await firestore.collection('user').doc(listId[i]).get();

      userchat = UserChat.fromMap(docSnap.data() as Map<String, dynamic>);
      if (i == 0) {
        name = name + getLastWordOfName(userchat.username!) + ", ";
      } else {
        name = name + getLastWordOfName(userchat.username!);
      }
    }
    return name + " và " + (numOfParticipants - 3).toString() + " người khác";
  }

  static Future<ChatRoom> createGroupChatroom(Map<String, bool> participantsId,
      String chatRoomId, String chatRoomName) async {
    participantsId.addAll({firebaseAuth.currentUser!.uid: true});
    final chatroom = ChatRoom(
        chatroomid: chatRoomId,
        chatroomname: chatRoomName,
        imageUrl: '',
        participants: participantsId,
        type: false);
    await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .set(chatroom.toMap());
    return chatroom;
  }

  static Future<void> leaveTheGroupChat(
      ChatRoom chatRoom, String userId) async {
    Map<String, bool> participants = chatRoom.participants!;
    participants.removeWhere((key, value) => key == userId);
    return await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .update({'participants': participants});
  }

  static Future<void> sendMessage(ChatRoom chatRoom, String msg) async {
    if (chatRoom.isRequests != ({})) {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatroomid)
          .get();
      Map<String, bool> participantsMap =
          Map<String, bool>.from(documentSnapshot['participants']);

      participantsMap.updateAll((key, value) => true);
      await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatroomid)
          .update({'participants': participantsMap});
    }
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final messageId = uuid.v8();
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    final Message message = Message(
      messageId: messageId,
      fromId: firebaseAuth.currentUser!.uid,
      msg: msg,
      read: '',
      sent: now,
      userName: userData.data()!['username'],
      userImage: userData.data()!['imageUrl'],
    );
    await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String chatRoomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<Map<String, String>> getNameInfo() async {
    Map<String, String> mapName = ({});

    QuerySnapshot chatRoomQuerySnapshot =
        await firestore.collection('chatrooms').get();
    for (QueryDocumentSnapshot room in chatRoomQuerySnapshot.docs) {
      if (room['chatroomname'] != '')
        mapName.addAll({room['chatroomid']: room['chatroomname']});
    }
    QuerySnapshot userQuerySnapshot = await firestore.collection('user').get();
    for (QueryDocumentSnapshot user in userQuerySnapshot.docs) {
      mapName.addAll({user['id']: user['username']});
    }
    return mapName;
  }

  static Future<void> acceptRequestsMessage(String chatRoomId) async {
    await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .update({'isRequests': ({})});
  }
  static Future<List<Message>> getSearchMessage (String _enteredWord, String chatRoomId) async{
    QuerySnapshot querySnapshot = await firestore
      .collection('chatrooms')
      .doc(chatRoomId)
      .collection('messages')
      .get();

    List<Message> listMessage =  querySnapshot.docs.map((e) => Message.fromMap(e.data() as Map<String,dynamic>)).toList();
    List<Message> listSearchMessage = [];
    for(Message message in listMessage){
      if(message.msg!.toLowerCase().contains(_enteredWord.toLowerCase())){
        listSearchMessage.add(message);
      }
    }
    return listSearchMessage;
  }
  static Future<void> updateStatus (bool isOnline) async{
    await firestore.collection('user').doc(firebaseAuth.currentUser!.uid).update({'isOnline' : isOnline});
  }
}
