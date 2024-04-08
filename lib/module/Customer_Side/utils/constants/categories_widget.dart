import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/screens/product_list_screen.dart';
import 'package:grocery_project/module/Customer_Side/services/product_service.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  productService _service = productService();
  List _cartList = [];

  @override
  void didChangeDependencies() {
    var store = Provider.of<StoreProvider>(context);
    super.didChangeDependencies();
    FirebaseFirestore.instance
        .collection("products")
        .where('seller.sellerUid', isEqualTo: store.storeDetails?["shopId"])
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        if (mounted) {
          setState(() {
            _cartList.add(doc["category"]["mainCategory"]);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<StoreProvider>(context);

    return FutureBuilder(
      future: _service.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Somethings went wrong."),
          );
        }
        if (_cartList.length == 0) {
          return Center(
            child: CupertinoActivityIndicator(
              color: Colors.green,
              animating: true,

            )
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  Text(
                    "Categories",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 18,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        return _cartList.contains(document['catName'])
                            ? InkWell(
                                onTap: () {
                                  store
                                      .getSelectedCategory(document['catName']);
                                  store.getSelectedSubCategory(null);
                                  pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(
                                        name: ProductListScreen.id),
                                    screen: ProductListScreen(),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     offset: Offset(2, 2),
                                          //     blurRadius: 12,
                                          //     color:
                                          //         Color.fromRGBO(0, 0, 0, 0.10),
                                          //   )
                                          // ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    document['img'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //Image.network(document['img']),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: Text(
                                                document['catName'],
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          18,
                                    ),
                                  ],
                                ),
                              )
                            : Text("");
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
