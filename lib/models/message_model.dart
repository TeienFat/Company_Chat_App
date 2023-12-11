class Message {
  String? messageId;
  String? fromId;
  String? msg;
  // String? createAt;
  String? read;
  String? sent;

  Message({
    required this.messageId,
    required this.fromId,
    required this.msg,
    // required this.createAt,
    required this.read,
    required this.sent,
  });

  Message.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    fromId = map['fromId'];
    msg = map['msg'];
    // createAt = map['createAt'];
    read = map['read'];
    sent = map['sent'];
  }

  Map<String, dynamic> toMap() {
    return ({
      'messageId': messageId,
      'fromId': fromId,
      'msg': msg,
      // 'createAt': createAt,
      'read': read,
      'sent': sent
    });
  }
}

enum TypeMessage { text, image, file, sound }
