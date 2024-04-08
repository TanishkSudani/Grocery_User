import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/order_provider.dart';
import 'package:grocery_project/module/Customer_Side/services/order_service.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;
  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Pick Up',
    'On The Way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    var _order = Provider.of<OrderProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: GestureDetector(onTap: (){Get.back();},child: Icon(CupertinoIcons.back,color: Colors.white,)),
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: C2ChipStyle.filled(
                  foregroundColor: Colors.white,
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  selectedStyle: C2ChipStyle.filled(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                ),
                value: tag,
                onChanged: ((val) {
                  if(val == 0)
                    {
                      setState(() {
                        _order.status = "";
                      });
                    }
                  setState(() {
                    tag = val;
                    if (tag > 0) {
                      _order.filterOrder(options[val]);
                    }
                  });
                }),
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderServices.orders
                    .where("userId", isEqualTo: user!.uid)
                    .where("orderStatus", isEqualTo:tag > 0 ? _order.status : null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:  CupertinoActivityIndicator(color: Colors.green,animating: true,radius: 20,)
                    );
                  }
                  if (snapshot.data!.size == 0) {
                    return Expanded(
                      child: Center(
                        child: Text(tag>0 ? "No ${options[tag]} orders" : " No orders continue shopping.."),
                      ),
                    );
                  }
                  return Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.1,
                      child: ListView(
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot document) {
                          // Map<String, dynamic> data =
                          //     document.data()! as Map<String, dynamic>;
                          return Column(
                            children: [
                              Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
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
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 14,
                                        child:_orderServices.statusIcon(document)
                                      ),
                                      title: Text(
                                        document["orderStatus"],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                _orderServices.statusColor(document),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "On ${DateFormat.yMMMd().format(
                                          DateTime.parse(document["timestamp"]),
                                        )}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      trailing: Text(
                                        "Amount : \₹${document["total"].toStringAsFixed(0)}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if(document["deliveryBoy"]["name"].length >2 )
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: ClipRRect(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          tileColor: Colors.green,
                                          title:Text(document["deliveryBoy"]["name"]),
                                          subtitle:Text(_orderServices.statusComment(document,),style: TextStyle(fontSize: 12),),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Image.network(document["deliveryBoy"]["image"],height: 24,),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ExpansionTile(
                                      expansionAnimationStyle: AnimationStyle(
                                        curve: Curves.bounceIn,
                                        duration: Duration(milliseconds: 590),
                                      ),
                                      title: Text(
                                        "Order Details",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      collapsedIconColor: Colors.black45,
                                      iconColor: _orderServices.statusColor(document),
                                      shape: Border(top: BorderSide(color: Colors.black)),
                                      subtitle: Text(
                                        "View order Details",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      children: [
                                        ListView.builder(
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Image.network(
                                                    document["products"][index]
                                                        ["productImage"]),
                                              ),
                                              title: Text(
                                                document["products"][index]
                                                    ["productName"],
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              subtitle: Text(
                                                "${document["products"][index]["qty"]} X \₹${document["products"][index]["price"].toStringAsFixed(0)} = \₹${document["products"][index]["total"].toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    color: Colors.grey, fontSize: 12),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Amount : \₹${document["total"].toStringAsFixed(0)} ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    "Payment Type : \₹${document["cod"] == true ? "COD" : " Pay Online"} ",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: document["products"].length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 12,
                                            bottom: 8,
                                            top: 8,
                                          ),
                                          child: Card(
                                            color: _orderServices.statusColor(document),
                                            elevation: 8,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Seller : ",
                                                        style:
                                                            TextStyle(fontSize: 12,color: Colors.white),
                                                      ),
                                                      Text(
                                                        document["seller"]
                                                            ["shopName"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Delivery Fee : ",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                      Text(
                                                        "\₹${document["deliveryFee"].toString()}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  int.parse(document["discount"]) > 0
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "Discount : ",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                  color: Colors.white
                                                              ),
                                                            ),

                                                            Text(
                                                              "\t\₹${
                                                                document["discount"]
                                                              }",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
