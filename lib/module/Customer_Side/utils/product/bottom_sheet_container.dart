import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/addToCart_widget.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/saveForLater.dart';
class BottomSheetContainer extends StatefulWidget {
  final DocumentSnapshot document;
  BottomSheetContainer(this.document);
  @override
  State<BottomSheetContainer> createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(flex: 1,child: SaveForLater(widget.document)),
          Flexible(flex: 1,child: AddToCartWidget(widget.document)),
        ],
      ),
    );
  }
}
