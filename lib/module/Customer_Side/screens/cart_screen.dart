import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/cart_provide.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/order_provider.dart';
import 'package:grocery_project/module/Customer_Side/screens/map_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/payment_home.dart';
import 'package:grocery_project/module/Customer_Side/screens/profile_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/razorpay_screen.dart';
import 'package:grocery_project/module/Customer_Side/services/cart_service.dart';
import 'package:grocery_project/module/Customer_Side/services/order_service.dart';
import 'package:grocery_project/module/Customer_Side/services/store_services.dart';
import 'package:grocery_project/module/Customer_Side/services/user_services.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/cart_list.dart';
import 'package:grocery_project/module/Customer_Side/utils/Cart/toggleCod.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot? document;

  const CartScreen({super.key, this.document});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  cartService _cart = cartService();
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? doc;
  TextStyle textStyle = TextStyle(color: Colors.grey);
  int discount = 30;
  int deliveryFee = 50;
  String location = "";
  String address = "";
  bool _loading = false;
  bool _checkingUser = false;

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
    // PaymentHome paymentHome = PaymentHome();
    // paymentHome.document = widget.document;
    getPrefs();
    super.initState();
    _storeServices.getShopDetails(widget.document?["sellerUid"]).then((value) {
      setState(() {
        doc = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    var userDetails = Provider.of<AP>(context);
    userDetails.getUserDetails();
    var _payable = _cartProvider.subTotal + deliveryFee - discount;
    final orderedProvider = Provider.of<OrderProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.document?["shopName"],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Row(
                children: [
                  Text(
                    "${_cartProvider.cartQty} ${_cartProvider.cartQty == 1 ? " Item, " : " Items, "}",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    "To Pay : \₹ ${_cartProvider.subTotal.toStringAsFixed(0)} ",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: userDetails.snapshot == null
            ? Container()
            : Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                color: Colors.blueGrey[900],
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  " Deliver to this address : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _loading = true;
                                    });
                                    locationData
                                        .getCurrentPosition()
                                        .then((value) {
                                      setState(() {
                                        _loading = false;
                                      });
                                      if (value != null) {
                                        pushNewScreenWithRouteSettings(
                                          context,
                                          screen: MapScreen(),
                                          settings:
                                              RouteSettings(name: MapScreen.id),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      } else {
                                        setState(() {
                                          _loading = true;
                                        });
                                        log("Permission not allowed");
                                        Get.toNamed(MapScreen.id);
                                      }
                                    });
                                  },
                                  child: Icon(CupertinoIcons.pencil),
                                ),
                              ],
                            ),
                            Text(
                              userDetails.snapshot?["firstName"] != null
                                  ? "${userDetails.snapshot?["firstName"]} : ${location},${address}"
                                  : "${location},${address}",
                              maxLines: 3,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " \₹ ${_cartProvider.subTotal.toStringAsFixed(0)} ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " (Including Taxes) ",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 10),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.green))),
                                backgroundColor: MaterialStatePropertyAll(
                                  Colors.green,
                                ),
                              ),
                              onPressed: () {
                                EasyLoading.show(status: "Please Wait.....");
                                _userServices
                                    .getUserData(user!.uid)
                                    .then((value) {
                                  if (value["firstName"] == "") {
                                    EasyLoading.dismiss();
                                    pushNewScreenWithRouteSettings(
                                      context,
                                      settings:
                                          RouteSettings(name: ProfileScreen.id),
                                      screen: ProfileScreen(),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  } else {
                                    if (_cartProvider.cod == false) {
                                      // Pay Online
                                      orderedProvider.totalPayment(_payable,widget.document?["shopName"]);
                                      EasyLoading.dismiss();
                                      Get.toNamed(PaymentHome.id)!.whenComplete(() {
                                        _saveOrder(_cartProvider, _payable,orderedProvider);
                                      });
                                    } else {
                                      //Cash On Delivery
                                      EasyLoading.dismiss();
                                      _saveOrder(_cartProvider, _payable,orderedProvider);
                                    }
                                    // EasyLoading.dismiss();
                                    // _saveOrder(_cartProvider, _payable);
                                  }
                                });
                              },
                              child: _checkingUser
                                  ? Center(
                                      child: Lottie.asset(
                                          'assets/lottie/loading.json'),
                                    )
                                  : Text(
                                      "Checkout",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        body: _cartProvider.cartQty > 0
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(bottom: 80),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade50,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        if (doc != null)
                          Container(
                            width: MediaQuery.of(context).size.width / 1.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 12,
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                )
                              ],
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  tileColor: Colors.white,
                                  leading: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          doc?["shopImage"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    doc?["shopName"],
                                  ),
                                  subtitle: Text(
                                    doc?["shopAddress"],
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                                CodToggle(),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        CartList(),
                        SizedBox(
                          height: 10,
                        ),
                        //Coupon
                        // Container(
                        //   color: Colors.white,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(10),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //             child: SizedBox(
                        //           height: 38,
                        //           child: TextField(
                        //             textAlign: TextAlign.start,
                        //             cursorColor: Colors.green,
                        //             decoration: InputDecoration(
                        //                 hintText: "Enter Voucher Code",
                        //                 hintStyle: TextStyle(color: Colors.grey),
                        //                 border: InputBorder.none,
                        //                 filled: true,
                        //                 fillColor: Colors.grey[300]),
                        //           ),
                        //         )),
                        //         TextButton(
                        //             child: Text("Apply".toUpperCase(),
                        //                 style: TextStyle(fontSize: 14)),
                        //             style: ButtonStyle(
                        //                 padding:
                        //                     MaterialStateProperty.all<EdgeInsets>(
                        //                         EdgeInsets.all(10)),
                        //                 foregroundColor:
                        //                     MaterialStateProperty.all<Color>(
                        //                         Colors.black),
                        //                 shape: MaterialStateProperty.all<
                        //                         RoundedRectangleBorder>(
                        //                     RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(4.0),
                        //                         side:
                        //                             BorderSide(color: Colors.grey)))),
                        //             onPressed: () {}),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //Bill Details
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4, top: 4, left: 4, bottom: 80),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.09,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 12,
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bill Details",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          " Basket Value",
                                          style: textStyle,
                                        ),
                                      ),
                                      Text(
                                        "\₹ ${_cartProvider.subTotal.toStringAsFixed(0)}",
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          " Discount ",
                                          style: textStyle,
                                        ),
                                      ),
                                      Text(
                                        "\₹ ${discount}",
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          " Delivery fee ",
                                          style: textStyle,
                                        ),
                                      ),
                                      Text(
                                        "\₹ ${deliveryFee}",
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          " Total Payable Amount ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        "\₹ ${_payable.toStringAsFixed(0)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.green.withOpacity(.3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              " Total Saving ",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          Text(
                                            " \₹ ${_cartProvider.saving.toStringAsFixed(0)}",
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(" Cart Is  Empty, Continue Shopping..."),
              ),
      ),
    );
  }

  _saveOrder(CartProvider cartProvider, payable,OrderProvider orderProvider) {
    _orderServices.saveOrder({
      'products': cartProvider.cartList,
      'userId': user!.uid,
      'deliveryFee': deliveryFee,
      'total': payable,
      'discount': discount.toStringAsFixed(0),
      'cod': cartProvider.cod,
      'seller': {
        'shopName': widget.document?["shopName"],
        'sellerId': widget.document?["sellerUid"]
      },
      'timestamp': DateTime.now().toString(),
      'orderStatus': 'Ordered',
      'deliveryBoy': {'name': '', 'phone': '', 'location': ''}
    }).then((value) {
      orderProvider.success = false;
      _cart.deleteCart().then((value) {
        _cart.CheckData().then((value) {
          EasyLoading.showSuccess("Order Placed Thank You");
          Get.back();
        });
      });
    });
  }
}
