import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/services/product_service.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/product_card_widget.dart';
import 'package:provider/provider.dart';

class RecentlyAdded extends StatelessWidget {
  const RecentlyAdded({super.key});

  @override
  Widget build(BuildContext context) {

    productService service  = productService();
    var _store = Provider.of<StoreProvider>(context);


    return FutureBuilder<QuerySnapshot>(
      future: service.product.where("published",isEqualTo: true).where("seller.sellerUid",isEqualTo: _store.storeDetails?["shopId"]).where("collection",isEqualTo: "Recently Added").orderBy("productName").limitToLast(5).get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container();
        }
        if(snapshot.data!.docs.isEmpty)
        {
          return Container();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  Text(
                    "Recently Added",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            new ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
