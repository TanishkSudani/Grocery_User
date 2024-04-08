import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_project/module/Customer_Side/provider/cart_provide.dart';
import 'package:grocery_project/module/Customer_Side/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentHome extends StatefulWidget {
  static const String id = 'payment-screen';
  // DocumentSnapshot? document;
  //
  // PaymentHome({super.key, this.document});

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  Razorpay razorpay = Razorpay();
  PaymentSuccessResponse? response;
  bool success = false;

  @override
  void initState() {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      success = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.showError("Payment Fail : " + response.error.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // EasyLoading.showSuccess("Payment Success : " + response..toString());
  }

  Future<void> openCheckout(OrderProvider orderedProvider) async {
    User? user = FirebaseAuth.instance.currentUser;
    var options = {
      'key': 'rzp_test_11spNzvwZFerAD',
      'amount': '${orderedProvider.amount}00',
      'name': 'Pay to ${orderedProvider.shopName}',
      'description': 'Buy Fresh Grocery Like Your Fresh Mood.',
      'prefill': {
        'contact': user!.phoneNumber,
        'email': user.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
      if (response!.paymentId != null) {
        setState(() {
          orderedProvider.pamentStatus(true);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {final _cartProvider = Provider.of<CartProvider>(context);
 // var _payable = _cartProvider.subTotal + deliveryFee - discount;
    final orderedProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Payments Methods",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Your Total bill : \₹${orderedProvider.amount}",
                style: TextStyle(fontSize: 18),
              ),
            ),
            InkWell(
              onTap: () {
                openCheckout(orderedProvider).whenComplete((){
                  if(success == true)
                    {
                      orderedProvider.pamentStatus(true);
                      // EasyLoading.dismiss();
                      // _saveOrder(_cartProvider, _payable);
                     Navigator.pop(context);
                     Navigator.pop(context);
                    }
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/20,
                width: MediaQuery.of(context).size.width/1.1,
                child: Text("Procced to pay",style: TextStyle(color: Colors.white,),),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(10),
                    color: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // cartService _cart = cartService();
  //
  // int discount = 30;
  // int deliveryFee = 50;
  // User? user = FirebaseAuth.instance.currentUser;
  // _saveOrder(CartProvider cartProvider, payable) {
  //   _orderServices.saveOrder({
  //     'products': cartProvider.cartList,
  //     'userId': user!.uid,
  //     'deliveryFee': deliveryFee,
  //     'total': payable,
  //     'discount': discount.toStringAsFixed(0),
  //     'cod': cartProvider.cod,
  //     'seller': {
  //       'shopName': widget.document?["shopName"],
  //       'sellerId': widget.document?["sellerUid"]
  //     },
  //     'timestamp': DateTime.now().toString(),
  //     'orderStatus': 'Ordered',
  //     'deliveryBoy': {'name': '', 'phone': '', 'location': ''}
  //   }).then((value) {
  //     _cart.deleteCart().then((value) {
  //       _cart.CheckData().then((value) {
  //         EasyLoading.showSuccess("Order Placed Thank You");
  //         Get.back();
  //       });
  //     });
  //   });
  // }
}
