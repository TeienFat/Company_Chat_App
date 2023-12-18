class Message {
  String? messageId;
  String? fromId;
  String? msg;
  String? read;
  String? sent;
  String? userName;
  String? userImage;
  Type? type;
  List<String>? deleted;

  Message(
      {required this.messageId,
      required this.fromId,
      required this.msg,
      required this.read,
      required this.sent,
      required this.userName,
      required this.userImage,
      required this.type,
      required this.deleted});

  Message.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    fromId = map['fromId'];
    msg = map['msg'];
    read = map['read'];
    sent = map['sent'];
    userName = map['userName'];
    userImage = map['userImage'];
    type = map['type'] == Type.image.name ? Type.image : Type.text;
    deleted = List<String>.from(map['deleted']);
  }

  Map<String, dynamic> toMap() {
    return ({
      'messageId': messageId,
      'fromId': fromId,
      'msg': msg,
      'read': read,
      'sent': sent,
      'userName': userName,
      'userImage': userImage,
      'type': type!.name,
      'deleted': deleted,
    });
  }
}

enum Type { text, image, file, sound }
