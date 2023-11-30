class Message{
  String? messageId;
  String? userId;
  String? text;
  String? createAt;
  String? read;
  String? sent;

  Message({
    required this.messageId,
    required this.userId,
    required this.text,
    required this.createAt,
    required this.read,
    required this.sent,
  });

  Message.fromMap(Map<String,dynamic> map){
    messageId = map['messageId'];
    userId = map['userId'];
    text = map['text'];
    createAt = map['createAt'];
    read = map['read'];
    sent = map['sent'];
  }

  Map<String,dynamic> toMap(){
    return({
      'messageId': messageId,
      'userId': userId,
      'text': text,
      'createAt': createAt,
      'read': read,
      'sent': sent
    });
  }
}
