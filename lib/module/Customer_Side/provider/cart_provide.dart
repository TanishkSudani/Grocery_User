import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  cartService _cart = cartService();
  double subTotal = 0.0;
  int cartQty = 0;
  double saving = 0.0;
  double distance = 0.0;
  bool cod = false;
  List cartList = [];
  QuerySnapshot? snapshot;
  DocumentSnapshot? document;

  Future<double> getCartTotal() async {
    var cartTotal = 0.0;
    var saving = 0.0;
    var _newList = [];
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user!.uid).collection("products").get();
    if (snapshot == null) {
      return 0.0;
    }
    snapshot.docs.forEach((doc) {
      if(!_newList.contains(doc.data()))
        {
          _newList.add(doc.data());
          this.cartList = _newList;
          notifyListeners();
        }
      cartTotal = cartTotal + doc["total"];
      saving = saving +
          ((doc["comparedPrice"] - doc["price"]) > 0
              ? (doc["comparedPrice"] - doc["price"])
              : 0);
    });

    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    this.saving = saving;
    notifyListeners();

    return cartTotal;
  }

  getDistance(distance) {
    this.distance = distance;
    notifyListeners();
  }

  getMethodToPay(index) {
    if (index == 0) {
      this.cod = false;
      notifyListeners();
    } else {
      this.cod = true;
      notifyListeners();
    }
  }

  getShopName() async {
    DocumentSnapshot doc = await _cart.cart.doc(_cart.user!.uid).get();
    if (doc.exists) {
      this.document = doc;
      notifyListeners();
    } else {
      this.document = null;
      notifyListeners();
    }
  }
}
