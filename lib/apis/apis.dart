import 'package:cloud_firestore/cloud_firestore.dart';

class APIs{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllUser(){
    return firestore.collection('user').where('id', isNotEqualTo: '111').snapshots();
  }
}