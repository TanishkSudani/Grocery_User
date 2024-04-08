import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number';
  static const ID = 'id';

  String? _number;
  String? _id;

  // ~~>> getter
  String get number => _number!;

  String get id => _id!;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _number = data[NUMBER];
    _id = data[ID];
  }
}
