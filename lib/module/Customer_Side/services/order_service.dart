
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");

  Color? statusColor(DocumentSnapshot document) {
    if (document['orderStatus'] == "Accepted") {
      return Color(0xffE4DEAE);
    }
    if (document['orderStatus'] == "Rejected") {
      return Colors.red;
    }
    if (document['orderStatus'] == "Pick Up") {
      return Color(0xff8eb15c);
    }
    if (document['orderStatus'] == "Delivered") {
      return Colors.green;
    }
    if (document['orderStatus'] == "On The Way") {
      return Color(0xff5cc593);
    }
    return Colors.greenAccent;
  }
  Icon? statusIcon(DocumentSnapshot document) {
    if (document['orderStatus'] == "Accepted") {
      return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
    }
    // if (document['orderStatus'] == "Rejected") {
    //   return Icon(Icons.cases_sharp,color: statusColor(document),);
    // }
    if (document['orderStatus'] == "Pick Up") {
      return Icon(Icons.cases_sharp,color: statusColor(document),);
    }
    if (document['orderStatus'] == "Delivered") {
      return Icon(Icons.shopping_bag_outlined,color: statusColor(document),);
    }
    if (document['orderStatus'] == "On The Way") {
      return Icon(Icons.delivery_dining,color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
  }
  String statusComment(document)
  {
    if(document["orderStatus"] == "Pick Up"){
      return 'Your order is accepted by ${document["deliveryBoy"]["name"]}';
    }
    if(document["orderStatus"] == "On The Way"){
      return 'Your delivery person ${document["deliveryBoy"]["name"]} is on the way';
    }
    if(document["orderStatus"] == "Delivered"){
      return 'Your order is now completed';
    }
    return 'Mr.${document["deliveryBoy"]["name"]} is on the way to pick up your order.';
  }
  Future<DocumentReference> saveOrder(Map<String, dynamic> data) {
    var result = orders.add(data);
    return result;
  }
}
