class Message {
  String? messageId;
  String? fromId;
  String? msg;
  String? read;
  String? sent;
  String? userName;
  String? userImage;

  Message({
    required this.messageId,
    required this.fromId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.userName,
    required this.userImage
  });

  Message.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    fromId = map['fromId'];
    msg = map['msg'];
    read = map['read'];
    sent = map['sent'];
    userName = map['userName'];
    userImage = map['userImage'];
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
    });
  }
}

enum TypeMessage { text, image, file, sound }
