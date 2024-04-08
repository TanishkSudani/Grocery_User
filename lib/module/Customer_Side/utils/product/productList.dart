import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/services/product_service.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/product_card_widget.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/product_filter_widget.dart';
import 'package:provider/provider.dart';

class productListWidget extends StatelessWidget {
  const productListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    productService service = productService();
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: service.product
          .where("published", isEqualTo: true)
          .where("category.mainCategory",
              isEqualTo: _storeProvider.selectedCategory)
          .where("category.subCategory",
              isEqualTo: _storeProvider.selectedSubCategory)
          .where("seller.sellerUid",
              isEqualTo: _storeProvider.storeDetails?["shopId"])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }
        return Column(
          children: [
            ProductFilterWidget(),
            Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "   ${snapshot.data!.docs.length} items",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ),
            new ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
