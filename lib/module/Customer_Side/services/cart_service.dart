import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cartService {
  CollectionReference cart = FirebaseFirestore.instance.collection("cart");
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
    cart.doc(user!.uid).set({
      'user': user!.uid,
      'sellerUid': document["seller"]["sellerUid"],
      'shopName': document["seller"]["shopName"],
    });

    return cart.doc(user!.uid).collection("products").add({
      'productId': document["productId"],
      'productName': document["productName"],
      'productImage' : document["productImg"],
      'weight': document["weight"],
      'price': document['price'],
      'comparedPrice': document["comparedPrice"],
      'sku': document["sku"],
      'qty': 1,
      'total': document['price'],
    });
  }

  Future<void> updateCartQty(docId, qty, total) async {
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection("products")
        .doc(docId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("product does not exist!");
          }
          transaction.update(documentReference, {
            'qty': qty,
            'total' : total,
          });

          // Return the new count
          return qty;
        })
        .then((value) => print("Update Cart"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user!.uid).collection("products").doc(docId).delete();
  }

  Future<void> CheckData() async {
    final snapShot = await cart.doc(user!.uid).collection("products").get();
    if (snapShot.docs.length == 0) {
      cart.doc(user!.uid).delete();
    }
  }

  Future<void> deleteCart() async {
    final result =
        await cart.doc(user!.uid).collection("products").get().then((snapShot) {
      for (DocumentSnapshot ds in snapShot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<String> checkSeller() async {
    final snapshot = await cart.doc(user!.uid).get();
    return snapshot.exists ? snapshot["shopName"] : "";
  }
}
