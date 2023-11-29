class User {
  String? id;
  String? imageUrl;
  String? username;
  bool? isOnline;
  String? email;

  User(
      {required this.id,
      required this.imageUrl,
      required this.username,
      required this.isOnline,
      required this.email});

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    imageUrl = map['imageUrl'];
    username = map['username'];
    isOnline = map['isOnline'];
    email = map['email'];
  }
  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "imageUrl": imageUrl,
      "username": username,
      "isOnline": isOnline,
      "email": email
    });
  }
}
