class UserChat{
  String? id;
  String? imageUrl;
  String? username;
  bool? isOnline;
  String? email;
  List<String>? blockUsers;
  String? token;

  UserChat({
    required this.id,
    required this.imageUrl,
    required this.username,
    required this.isOnline,
    required this.email,
    required this.blockUsers,
    required this.token,
  });

  UserChat.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    imageUrl = map['imageUrl'];
    username = map['username'];
    isOnline = map['isOnline'];
    email = map['email'];
    blockUsers = List<String>.from(map['blockUsers']);
    token = map['token'];
  }
  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "imageUrl": imageUrl,
      "username": username,
      "isOnline": isOnline,
      "email": email,
      "blockUsers": blockUsers,
      "token": token
    });
  }
}
