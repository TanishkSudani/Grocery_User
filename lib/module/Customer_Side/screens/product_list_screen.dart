import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/productList.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = "product-list-screen";

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          store.selectedCategory,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          productListWidget(),
        ],
      ),
    );
  }
}
