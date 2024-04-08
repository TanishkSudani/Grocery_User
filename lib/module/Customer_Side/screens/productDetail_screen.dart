import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/bottom_sheet_container.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String id = "product-detail-screen";
  final DocumentSnapshot? document;

  ProductDetailScreen({this.document});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String offer = ((document?["comparedPrice"] - document?["price"]) /
            document?["comparedPrice"] *
            100)
        .toStringAsFixed(0);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          document?["brand"],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomSheet: BottomSheetContainer(document!),
      body: Stack(
        children: [
          Positioned(
            top: size.height / 35,
            left: size.width / 20,
            right: size.width / 20,
            child: Container(
              alignment: Alignment.topCenter,
              height: size.height / 4,
              width: size.width / 1.1,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 10,
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  )
                ],
              ),
              child: Container(
                height: size.height / 6,
                width: size.width / 2,
                child: Image.network(document?["productImg"]),
              ),
            ),
          ),
          Positioned(
            top: size.height / 5,
            left: size.width / 20,
            right: size.width / 20,
            child: Container(
              height: size.height / 1.9,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    //  offset: Offset(2, 2),
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.20),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height / 4.4,
            left: size.width / 10,
            right: size.width / 10,
            child: Container(
              height: size.height / 10,
              width: size.width / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.green),
                boxShadow: [
                  BoxShadow(
                    //  offset: Offset(2, 2),
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 60,
                      ),
                      Text(
                        document?["productName"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width / 25),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 40,
                      ),
                      Text(
                        "\₹${document?["comparedPrice"].toStringAsFixed(0)}",
                        style: TextStyle(color: Colors.grey,decoration: TextDecoration.lineThrough),

                      ),
                      SizedBox(width: size.width/20,),
                      Text("MRP :  ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                      Expanded(
                        child: Text(
                          "\₹${document?["price"].toStringAsFixed(0)}/${document?["weight"]}",
                          // style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height / 2.75,
            left: size.width / 10,
            right: size.width / 10,
            child: Container(
              height: size.height / 5.5,
              width: size.width / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.green),
                boxShadow: [
                  BoxShadow(
                    //  offset: Offset(2, 2),
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Container(
                    height: size.height/6.5,
                    width: size.width/1.1,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                            child: ExpandableText(
                              document?["description"],
                              expandText: ' view more ',
                              collapseText: " less more ",
                              maxLines: 5,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height / 1.7,
            left: size.width / 10,
            right: size.width / 10,
            child: Container(
              height: size.height / 10,
              width: size.width / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.green),
                boxShadow: [
                  BoxShadow(
                    //  offset: Offset(2, 2),
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: size.height / 80,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width / 60,
                          ),
                          Text(
                            "Product Id : ${document?["sku"]}",
                            style: TextStyle(
                                fontSize: size.height / 60),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height / 150,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width / 60,
                          ),
                          Text(
                            "Seller : ${document?["seller"]["shopName"]}",
                            style: TextStyle(
                                fontSize: size.height / 60),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height / 2.75,
            left: size.width / 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(3),
                  bottomRight: Radius.circular(3),

                ),
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "About this product",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height / 1.7,
            left: size.width / 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(3),
                  bottomRight: Radius.circular(3),

                ),
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Other Product Information",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          if (offer.length > 0)
            Positioned(
              top: size.height / 4.4,
              left: size.width / 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),

                  ),
                  color: Colors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "${offer}% OFF",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}
