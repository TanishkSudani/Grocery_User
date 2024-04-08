import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/counter.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot? document;

  const CartCard({super.key, this.document});

  @override
  Widget build(BuildContext context) {
    double saving = document?["comparedPrice"] - document?["price"];
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 12,
                color: Color.fromRGBO(0, 0, 0, 0.10),
              )
            ],
          ),
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          document?["productImage"],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(document?["productName"]),
                          Text(
                            document?["weight"],
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "\₹${document?["price"].toStringAsFixed(0)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (document!["comparedPrice"] != document!["price"])
                            Text(
                              "\₹${document!["comparedPrice"].toString()}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: counterForCard(document: document)),
                if (saving > 0)
                  Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "\₹ ${saving.toStringAsFixed(0)}",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                " Saved ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      //  SizedBox(height: MediaQuery.of(context).size.height/50,),
      ],
    );
  }
}
