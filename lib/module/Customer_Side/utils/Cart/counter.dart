import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/services/cart_service.dart';

class counterForCard extends StatefulWidget {
  final DocumentSnapshot? document;

  const counterForCard({super.key, this.document});

  @override
  State<counterForCard> createState() => _counterForCardState();
}

class _counterForCardState extends State<counterForCard> {
  User? user = FirebaseAuth.instance.currentUser;
  cartService _service = cartService();
  int _qty = 1;
  String _docId = "";
  bool _exist = false;
  bool _updating = false;

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection("products")
        .where("productId", isEqualTo: widget.document?["productId"])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          if (doc["productId"] == widget.document?["productId"]) {
            if(mounted)
              {
                setState(() {
                  _qty = doc["qty"];
                  _docId = doc.id;
                  _exist = true;
                });
              }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _exist = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return _exist
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                        });
                        if (_qty == 1) {
                          _service.removeFromCart(_docId).then((value) {
                            setState(() {
                              _updating = false;
                              _exist = false;
                            });
                            _service.CheckData();
                          });
                        }
                        if (_qty > 0) {
                          setState(() {
                            _qty--;
                          });
                          var total = _qty * widget.document?["price"];
                          _service
                              .updateCartQty(_docId, _qty, total)
                              .then((value) {
                            setState(() {
                              _updating = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        child: Icon(
                          _qty == 1 ? Icons.delete_outline : Icons.remove,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      alignment: Alignment.center,
                      child: FittedBox(
                          child: _updating
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _qty.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                          _qty++;
                        });
                        var total = _qty * widget.document?["price"];
                        _service
                            .updateCartQty(_docId, _qty, total)
                            .then((value) {
                          setState(() {
                            _updating = false;
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        child: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return InkWell(
                onTap: () {
                  EasyLoading.show(status: "Added to Cart");
                  _service.checkSeller().then((shopName) {
                    if (shopName == widget.document?["seller"]["shopName"]) {
                      setState(() {
                        _exist = true;
                      });
                      _service.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess("Added To Cart");
                      });
                      return;
                    }
                    if (shopName == null) {
                      setState(() {
                        _exist = true;
                      });
                      _service.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess("Added To Cart");
                      });
                      return;
                    }
                    if (shopName != widget.document?["seller"]["shopName"]) {
                      EasyLoading.dismiss();
                      showDialog(shopName);
                    }
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height/22,
                  width: MediaQuery.of(context).size.width/4,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            });
  }

  showDialog(shopName) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Replace cart item?"),
            content: Text(
                "Your cart contains item from ${shopName}. Do you want to discard the selection and add item from ${widget.document?["seller"]["shopName"]}"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  _service.deleteCart().then((value) {
                    _service.addToCart(widget.document).then((value) {
                      setState(() {
                        _exist = true;
                      });
                      Get.back();
                    });
                  });
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
  }
}
