import 'package:cloud_firestore/cloud_firestore.dart';

class productService{
  CollectionReference category = FirebaseFirestore.instance.collection("category");
  CollectionReference product = FirebaseFirestore.instance.collection("products");
}