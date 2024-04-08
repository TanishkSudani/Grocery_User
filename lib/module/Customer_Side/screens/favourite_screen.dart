import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/services/favourite_service.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/favProductCard.dart';
import 'package:lottie/lottie.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  favProduct service = favProduct();

  @override
  void initState() {
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(onTap: (){Get.back();},child: Icon(CupertinoIcons.back,color: Colors.white,)),
          backgroundColor: Colors.green,
          title: Text(
            "Favourites",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('favourites').get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return  CupertinoActivityIndicator(
                animating: true,
                color: Colors.green,
              );
            }
            return snapshot.data!.size > 0 ? SingleChildScrollView(
              child: Column(
                children: [
                  new ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          String productId = document.id;
                      return Slidable( key: ValueKey(0),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                onPressed: (BuildContext context)async{
                                  await FirebaseFirestore.instance.collection('favourites').doc(productId).delete();
                                  if (mounted){
                                    setState(() {
                                    });
                                  }
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: CupertinoIcons.bin_xmark,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: new favProductCard(document));
                    }).toList(),
                  ),
                ],
              ),
            ):Center(child: Text('Sorry, No favourite added by you..'),);
          },
        ),
      ),
    );
  }

}
