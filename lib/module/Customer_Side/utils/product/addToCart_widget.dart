import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_project/module/Customer_Side/services/cart_service.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/counter_widget.dart';

class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot document;

  AddToCartWidget(this.document);

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  cartService _cartService = cartService();
  User? user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exist = false;
  int _qty = 1;
  String _docId = "";

  @override
  void initState() {
    super.initState();
    getCartData();
  }

  getCartData() async {
    final snapshot =
        await _cartService.cart.doc(user!.uid).collection("products").get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection("products")
        .where("productId", isEqualTo: widget.document["productId"])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["productId"] == widget.document["productId"]) {
          if (mounted) {
            setState(() {
              _exist = true;
              _qty = doc["qty"];
              _docId = doc.id;
            });
          }
        }
      });
    });

    return _loading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          )
        : _exist
            ? CounterWidget(
                document: widget.document,
                qty: _qty,
                docId: _docId,
              )
            : InkWell(
                onTap: () {
                  EasyLoading.show(status: "Adding To Cart");
                  _cartService.addToCart(widget.document).then((value) {
                    setState(() {
                      _exist = true;
                    });
                    EasyLoading.showSuccess("Added To Cart");
                  });
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20)
                    ),
                  color: Colors.green,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.cart,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Add To Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
