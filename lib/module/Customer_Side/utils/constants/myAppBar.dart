import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/database/product_model.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/screens/map_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/productDetail_screen.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/counter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  static List<Product> products = [];
  String offer = "";
  String shopName = "";
  DocumentSnapshot? document;
  String location = "";
  String address = "";

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Location = prefs.getString('location');
    String? Address = prefs.getString('address');
    setState(() {
      location = Location!;
      address = Address!;
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          document = doc;
          offer = ((doc["comparedPrice"] - doc["price"]) /
              doc["comparedPrice"] *
              100)
              .toStringAsFixed(0);
          products.add(
            Product(
                brand: doc["brand"],
                comparedPrice: doc["comparedPrice"],
                productName: doc["productName"],
                image: doc["productImg"],
                price: doc["price"],
                weight: doc["weight"],
                shopName: doc["seller.shopName"],
                category: doc["category.mainCategory"],
                document: doc
            ),
          );
        });
      });
    });
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    products.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<StoreProvider>(context);
    final size = MediaQuery
        .of(context)
        .size;
    final locationData = Provider.of<LocationProvider>(context);
    return SliverAppBar(

      automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
      elevation: 0,
      floating: true,
      snap: true,
      title: TextButton(
        onPressed: () {
          locationData.getCurrentPosition().then((value) {
            if (value != null) {
              pushNewScreenWithRouteSettings(context,
                screen: MapScreen(),
                settings: RouteSettings(name: MapScreen.id),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            } else {
              log("Permission not allowed");
              Get.toNamed(MapScreen.id);
            }
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  location == null ? "Address Not Set" : "${location}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: size.height / 55,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  size: size.height / 42,
                  color: Colors.white,
                ),
              ],
            ),
            Container(
              width: size.width / 1.34,
              child: Text(
                address == null ? "Tap hear to set delivery location" : address,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: size.height / 60,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 15, right: 15),
          child: InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchPage<Product>(
                  onQueryUpdate: print,
                  items: products,
                  searchLabel: 'Search products',
                  searchStyle: TextStyle(fontSize: 16, color: Colors.green),
                  suggestion: const Center(
                    child: Text('Filter product by name, category or price'),
                  ),
                  failure: const Center(
                    child: Text('No product found 🥲'),
                  ),
                  filter: (product) =>
                  [
                    product.productName,
                    product.category,
                    product.brand,
                    product.price.toString(),
                  ],
                  // sort: (a, b) => a.compareTo(b),
                  builder: (product) =>
                      Container(
                        height: 160,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width / 30,
                              ),
                              Stack(
                                children: [
                                  Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () {
                                        pushNewScreenWithRouteSettings(
                                          context,
                                          settings: RouteSettings(
                                              name: ProductDetailScreen.id),
                                          screen: ProductDetailScreen(
                                            document: product.document,
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      child: SizedBox(
                                        height: 140,
                                        width: 130,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          child: Hero(
                                            tag: "product${product
                                                .document["productName"]}",
                                            child: Image.network(
                                              product.document["productImg"],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (double.parse(offer) > 0)
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "${offer} %off",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "${product.document["brand"]}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "${product
                                                .document["productName"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width /
                                                10,
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius
                                                  .circular(4),
                                            ),
                                            child: Text(
                                              "${product.document["weight"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "\₹${product
                                                    .document["price"]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                "\₹${product
                                                    .document["comparedPrice"]}",
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration.lineThrough,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        counterForCard(
                                          document: product.document,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
              );
            },
            child: Container(
              height: size.width / 7.2,
              width: size.width / 1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: Row(
                children: [
                  SizedBox(width: size.width / 30,),
                  Icon(Icons.search),
                  SizedBox(width: size.width / 40,),
                  Text("Search Products")
                ],
              ),
            ),

          ),
        ),
      ), //Search
    );
  }
}
