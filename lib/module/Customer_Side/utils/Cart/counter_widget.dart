import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/services/cart_service.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/addToCart_widget.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final String docId;
  final int qty;

  CounterWidget(
      {required this.document, required this.qty, required this.docId});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  cartService _service = cartService();
  int _qty = 0;
  bool _updating = false;
  bool _exist = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _qty = widget.qty;
    });
    return _exist ? Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 56,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                    });
                    if (_qty == 1) {
                      _service.removeFromCart(widget.docId).then((value) {
                        setState(() {
                          _updating = false;
                          _exist=false;
                        });
                        _service.CheckData();
                      });
                    }
                    if (_qty > 0) {
                      setState(() {
                        _qty--;
                      });
                      var total = _qty * widget.document["price"];
                      _service.updateCartQty(widget.docId, _qty,total).then((value) {
                        setState(() {
                          _updating = false;
                        });
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _qty == 1 ? Icons.delete_outline : Icons.remove,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 8, top: 8),
                    child: _updating
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            "${_qty.toString()}",
                            style: TextStyle(color: Colors.green),
                          ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _updating = true;
                      _qty++;
                    });
                    var total = _qty * widget.document["price"];
                    _service.updateCartQty(widget.docId, _qty,total).then((value) {
                      setState(() {
                        _updating = false;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ): AddToCartWidget(widget.document);
  }
}
