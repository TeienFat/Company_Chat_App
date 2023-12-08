class ChatRoom{
  String? chatroomid;
  String? chatroomname;
  String? imageUrl;
  Map<String,bool>? participants;
  bool? type;

  ChatRoom({
    required this.chatroomid,
    required this.chatroomname,
    required this.imageUrl,
    required this.participants,
    required this.type,
  });
  
  ChatRoom.fromMap(Map<String,dynamic> map){
    chatroomid = map['chatroomid'];
    chatroomname = map['chatroomname'];
    imageUrl = map['imageUrl'];
    participants = Map<String,bool>.from(map['participants']);
    type = map['type'];
  }

  Map<String, dynamic> toMap(){
    return ({
      'chatroomid': chatroomid,
      'chatroomname': chatroomname,
      'imageUrl': imageUrl,
      'participants': participants,
      'type': type,
    });
  }
}