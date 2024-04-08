import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:grocery_project/module/Customer_Side/database/product_model.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/screens/productDetail_screen.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/counter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class vendorHomeAppBar extends StatefulWidget {
  const vendorHomeAppBar({super.key});

  @override
  State<vendorHomeAppBar> createState() => _vendorHomeAppBarState();
}

class _vendorHomeAppBarState extends State<vendorHomeAppBar> {
  static List<Product> products = [];
  String offer = "";
  String shopName = "";
  String rate = "";
  double r = 3.5;
  DocumentSnapshot? document;

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
                document: doc),
          );
        });
      });
    });
    // TODO: implement initState
    super.initState();
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
    var auth = Provider.of<AP>(context);

    mapLauncher() async {
      GeoPoint location = store.storeDetails?["shopLocation"];
      final availableMaps = await MapLauncher.installedMaps;

      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: " ${store.storeDetails?["shopName"]} is here ",
      );
    }

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: 260,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.green,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 3, right: 10, left: 10),
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/shopPhoto.jpg",
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.7),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      store.storeDetails?["shopDialog"],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      store.storeDetails?["shopAddress"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      store.storeDetails?["shopEmail"],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Distance :${store.distance} km",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RatingStars(
                          value: r,
                          onValueChanged: (v) {
                            setState(() {
                              r = v;
                            });
                          },
                          starBuilder: (index, color) => Icon(
                            CupertinoIcons.heart,
                            color: color,
                          ),
                          starCount: 5,
                          starSize: 25,
                          valueLabelColor: CupertinoColors.activeGreen,
                          valueLabelTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          valueLabelRadius: 10,
                          maxValue: 5,
                          starSpacing: 2,
                          maxValueVisibility: true,
                          valueLabelVisibility: true,
                          animationDuration: Duration(milliseconds: 1000),
                          valueLabelPadding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 8),
                          valueLabelMargin: const EdgeInsets.only(right: 8),
                          starOffColor: CupertinoColors.activeGreen,
                          starColor: CupertinoColors.white,
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    'tel:${store.storeDetails?["shopMobileNo"]}'),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.phone,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              mapLauncher();
                            },
                            icon: Icon(
                              CupertinoIcons.map,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "${store.storeDetails?["shopName"]}",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              shopName = store.storeDetails?["shopName"];
            });
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
                filter: (product) => [
                  product.productName,
                  product.category,
                  product.brand,
                  product.price.toString(),
                ],
                // sort: (a, b) => a.compareTo(b),
                builder: (product) => product.shopName != shopName
                    ? Container()
                    : Container(
                        height: 160,
                        width: MediaQuery.of(context).size.width,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Hero(
                                            tag:
                                                "product${product.document["productName"]}",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${product.document["brand"]}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "${product.document["productName"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                10,
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                                                "\₹${product.document["price"]}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                "\₹${product.document["comparedPrice"]}",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
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
          icon: Icon(
            CupertinoIcons.search,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
