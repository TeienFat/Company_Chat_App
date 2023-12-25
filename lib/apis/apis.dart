import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:company_chat_app_demo/models/chatroom_model.dart';
import 'package:company_chat_app_demo/models/message_model.dart';
import 'package:company_chat_app_demo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIs {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static String token = "";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore.collection('user').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChatroom() {
    return firestore
        .collection('chatrooms')
        .where('participants.${firebaseAuth.currentUser!.uid}', isEqualTo: true)
        .snapshots();
  }

  static Future<String> saveMedia(
      int type, String mediaName, File mediaFile, String path) async {
    final ext = mediaFile.path.split('.').last;
    final storageRef =
        await fireStorage.ref().child(path).child('${mediaName}.$ext');
    switch (type) {
      case 0:
        await storageRef.putFile(
            mediaFile, SettableMetadata(contentType: 'image/$ext'));
        break;
      case 1:
        await storageRef.putFile(
            mediaFile, SettableMetadata(contentType: 'video/$ext'));
        break;
    }

    return await storageRef.getDownloadURL();
  }

  static Future<void> createNewUser(
      String userId, String imageUrl, String userName, String email) async {
    final user = UserChat(
        id: userId,
        imageUrl: imageUrl,
        username: userName,
        isOnline: true,
        email: email,
        blockUsers: [],
        token: "");
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
    } else {
      chatroom = ChatRoom(
        chatroomid: newChatroomId,
        chatroomname: '',
        imageUrl: '',
        participants: ({firebaseAuth.currentUser!.uid: false, userId: false}),
        type: true,
        isRequests: ({}),
        lastSend: '0',
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

  static Future<MessageChat> getMessageFromId(
      String chatRoomId, String messageId) async {
    DocumentSnapshot docSnap = await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .get();
    MessageChat messageChat =
        MessageChat.fromMap(docSnap.data() as Map<String, dynamic>);
    return messageChat;
  }

  static Future<void> updateUserName(String userName) async {
    return firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'username': userName});
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

    participantsMap.update(firebaseAuth.currentUser!.uid, (value) => false);
    await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .update({'participants': participantsMap});
    var querySnapshot = await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .get();
    participantsMap.remove(firebaseAuth.currentUser!.uid);
    querySnapshot.docs.forEach((element) {
      element.reference.update({'receivers': participantsMap.keys});
    });
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
    if ((numOfParticipants - 3) <= 0)
      return name;
    else
      return name + " và " + (numOfParticipants - 3).toString() + " người khác";
  }

  static Future<ChatRoom> createGroupChatroom(Map<String, bool> participantsId,
      String chatRoomId, String chatRoomName) async {
    UserChat userchat;

    DocumentSnapshot docSnap = await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    userchat = UserChat.fromMap(docSnap.data() as Map<String, dynamic>);
    participantsId.addAll({firebaseAuth.currentUser!.uid: true});
    final chatroom = ChatRoom(
        chatroomid: chatRoomId,
        chatroomname: chatRoomName,
        imageUrl: '',
        participants: participantsId,
        type: false,
        isRequests: ({}),
        lastSend: '0');
    await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .set(chatroom.toMap());
    await sendMessage(
        chatroom, userchat.username! + " đã tạo nhóm", Type.notification, null);
    return chatroom;
  }

  static Future<void> updateNameChatRoom(
      String chatRomID, String chatRoomName) async {
    return firestore
        .collection('chatrooms')
        .doc(chatRomID)
        .update({'chatroomname': chatRoomName});
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

  static Future<void> sendMessage(
      ChatRoom chatRoom, String msg, Type type, String? messRepId) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('chatrooms').doc(chatRoom.chatroomid).get();

    Map<String, bool> participantsMap =
        Map<String, bool>.from(documentSnapshot['participants']);
    if (chatRoom.type!) {
      String user = participantsMap.keys
          .firstWhere((element) => element != firebaseAuth.currentUser!.uid)
          .toString();
      if (!await isBlockedByOther(user)) {
        participantsMap.updateAll((key, value) => true);
        await firestore
            .collection('chatrooms')
            .doc(chatRoom.chatroomid)
            .update({'participants': participantsMap});
      } else {
        participantsMap.removeWhere((key, value) => key == user);
      }
    }
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final messageId = uuid.v8();

    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    UserChat user = UserChat.fromMap(userData.data()!);

    final MessageChat message = MessageChat(
        messageId: messageId,
        fromId: firebaseAuth.currentUser!.uid,
        msg: msg,
        read: '',
        sent: now,
        userName: user.username,
        userImage: user.imageUrl,
        type: type,
        receivers: participantsMap.keys.toList(),
        isPin: "",
        messageReplyId: messRepId != null ? messRepId : null);
    await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .update({'lastSend': now});
    await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap())
        .then((value) {
      participantsMap.keys
          .where((element) => element != firebaseAuth.currentUser!.uid)
          .toList()
          .forEach((element) async {
        final userChatData = await FirebaseFirestore.instance
            .collection('user')
            .doc(element)
            .get();
        UserChat userChat = UserChat.fromMap(userChatData.data()!);
        sendNotification(
            userChat,
            user.username!,
            chatRoom,
            type == Type.text
                ? msg
                : (type == Type.image
                    ? 'Đã gửi một ảnh'
                    : (type == Type.video
                        ? 'Đã gửi một video'
                        : 'Đã gửi một file')));
      });
    });
  }

  static Future<void> sendMediaMessage(
      int type, ChatRoom chatRoom, File mediaFile, String? messRepId) async {
    final mediaName = DateTime.now().millisecondsSinceEpoch;
    var mediaUrl;
    switch (type) {
      case 0:
        mediaUrl = await saveMedia(
            0, mediaName.toString(), mediaFile, 'message_images');
        await sendMessage(chatRoom, mediaUrl, Type.image,
            messRepId != null ? messRepId : null);
        break;
      case 1:
        mediaUrl = await saveMedia(
            1, mediaName.toString(), mediaFile, 'message_images');
        await sendMessage(chatRoom, mediaUrl, Type.video,
            messRepId != null ? messRepId : null);
        break;
    }
  }

  static Future<void> updateMessageReadStatus(
      String chatRoomId, String messageId) async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();

    firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .update({'read': now});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String chatRoomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receivers', arrayContains: firebaseAuth.currentUser!.uid)
        //.orderBy('sent', descending: true)
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

  static Future<List<MessageChat>> getSearchMessage(
      String _enteredWord, String chatRoomId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .get();

    List<MessageChat> listMessage = querySnapshot.docs
        .map((e) => MessageChat.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    List<MessageChat> listSearchMessage = [];
    for (MessageChat message in listMessage) {
      if (message.msg!.toLowerCase().contains(_enteredWord.toLowerCase())) {
        listSearchMessage.add(message);
      }
    }
    return listSearchMessage;
  }

  static Future<void> updateStatus(bool isOnline) async {
    await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'isOnline': isOnline, 'token': token});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getInfoUser(
      String userId) {
    return firestore
        .collection('user')
        .where('id', isEqualTo: userId)
        .snapshots();
  }

  static Future<void> blockUser(String idUser) async {
    await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update(
      {
        'blockUsers': FieldValue.arrayUnion([idUser]),
      },
    );
    var querySnapshot = await firestore.collection('chatrooms').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, bool> mapParticipants =
          Map<String, bool>.from(doc['participants']);
      String chatroomId = doc['chatroomid'];
      bool type = doc['type'];
      if (type) if (mapParticipants.containsKey(idUser) &&
          mapParticipants.containsKey(firebaseAuth.currentUser!.uid)) {
        mapParticipants.update(firebaseAuth.currentUser!.uid, (value) => false);
        await firestore
            .collection('chatrooms')
            .doc(chatroomId)
            .update({'participants': mapParticipants});
      }
    }
  }

  static Future<bool> isBlockedByOther(String idUser) async {
    DocumentSnapshot document =
        await firestore.collection('user').doc(idUser).get();
    List<dynamic> listBlockUsers = document['blockUsers'];
    if (listBlockUsers.contains(firebaseAuth.currentUser!.uid)) {
      return true;
    } else
      return false;
  }

  static Future<bool> hasBlockOther(String idUser) async {
    DocumentSnapshot document = await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    List<dynamic> listBlockUsers = document['blockUsers'];
    if (listBlockUsers.contains(idUser)) {
      return true;
    } else {
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String chatRoomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> getFirebaseMessageingToken() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((t) {
      if (t != null) {
        token = t;
        print('Push token: $t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> sendNotification(
      UserChat userChat, String username, ChatRoom chatroom, String msg) async {
    try {
      String chatRoomName = await getChatRoomName(chatroom);
      final body;
      if (chatroom.type!) {
        body = {
          "to": userChat.token,
          "notification": {
            "title": username,
            "body": msg,
            "android_channel_id": "chat"
          },
        };
      } else {
        body = {
          "to": userChat.token,
          "notification": {
            "title": chatroom.chatroomname!.isNotEmpty
                ? chatroom.chatroomname!
                : chatRoomName,
            "body": username + ": " + msg,
            "android_channel_id": "chat"
          },
        };
      }
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAyIzqsa4:APA91bGuZ6FkmLcZmsYIZtjNamGactWlmyXVRL8yuiwNjk4-Tf7ukUo_TWurGtw2b7pZZBneByzKJv_F8TAzN01hW93bcV88Coi-cRwX8tnm0_pcU7gMHVplwOyZQ3zyw_dhaNCrvetl'
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('\nSendNotification: $e');
    }
  }

  static Future<void> pinMessage(
      String messageId, String chatroomId, bool pin) async {
        if(pin){
        final now = DateTime.now().millisecondsSinceEpoch.toString();
          await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId)
        .update({'isPin': now});
        }else{
          await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId)
        .update({'isPin': ""});
        }
  }

  static Future<bool> checkPinMessage(
      String messageId, String chatroomId) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId)
        .get();
    String isPin = documentSnapshot['isPin'];
    if (isPin.isNotEmpty) {
      return true;
    } else
      return false;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPinMessage(
      String chatroomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .where('isPin', isNotEqualTo: "")
        .snapshots();
  }
}
