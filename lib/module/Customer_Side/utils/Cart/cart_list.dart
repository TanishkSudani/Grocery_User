import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/services/cart_service.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/cart_card.dart';
import 'package:lottie/lottie.dart';

class CartList extends StatefulWidget {
  final DocumentSnapshot? document;

  const CartList({super.key, this.document});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    cartService _cartService = cartService();
    return StreamBuilder<QuerySnapshot>(
      stream: _cartService.cart
          .doc(_cartService.user!.uid)
          .collection("products")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Center(
            child:  Lottie.asset('assets/lottie/loading.json'),
          );
        }
        return Container(
          width: MediaQuery.of(context).size.width/1.09,
        //  color: Colors.pink,
          child: SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return CartCard(
                  document: document,
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10), // Adjust the height as needed
              itemCount: snapshot.data!.docs.length,
            ),
          ),
        );
      },
    );
  }
}
