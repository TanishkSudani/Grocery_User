import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
   String shopname = "";
   PaymentScreen({required this.shopname});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
