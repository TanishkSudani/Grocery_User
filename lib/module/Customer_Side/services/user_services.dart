import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collections = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ~~>> Create New User
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collections).doc(id).set(values);
  }

  // ~~>> Update User Data
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collections).doc(id).update(values);
  }

  // ~~>> Get User Data by User Id
  Future<DocumentSnapshot> getUserData(String id) async {
    var result = await _firestore.collection(collections).doc(id).get();
    return result;
  }
}
