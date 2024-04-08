import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/services/store_services.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/constants.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

class NearByStore extends StatefulWidget {
  @override
  State<NearByStore> createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {


  @override
  Widget build(BuildContext context) {
    StoreServices storeServices = StoreServices();
    final storeData = Provider.of<StoreProvider>(context);
    final size = MediaQuery.of(context).size;
    storeData.getUserLocationData(context);
    String getDistance(location) {
      var distance = Geolocator.distanceBetween(storeData.userLatitude,
          storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: storeServices.getNearByStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Lottie.asset('assets/lottie/loading.json'),
            );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Our Store",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "Find out quality products",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                FirestorePagination(
                  bottomLoader:  Lottie.asset('assets/lottie/loading.json'),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  viewType: ViewType.list,
                  query: storeServices.getNearByStorePagination(),
                  itemBuilder: (context, documentSnapshot, index) {
                    final data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    return Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: (){

                            showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text("Sorry.. 🥲"),
                                    content: Text(
                                        "We expand our service in all our india so, now you can buy only from your nearest store. \n sorry for inconvenience"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  );
                                });

                        },
                        child: Container(
                          width: size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 110,
                                child: Card(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      data["shopImage"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      data["shopName"],
                                      style: storeCardTextStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    data["shopDialog"],
                                    style: storeCardTextStyle,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    width: size.width - 130,
                                    child: Text(
                                      data["shopAddress"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: storeCardTextStyle,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "${getDistance(data["shopLocation"])}km",
                                    overflow: TextOverflow.ellipsis,
                                    style: storeCardTextStyle,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "3.2",
                                        style: storeCardTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/city.jpg",
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          right: 10.0,
                          top: 10,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Made By :",
                                  style: TextStyle(color: Colors.black12),
                                ),
                                Text(
                                  "Project 64",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // RefreshIndicator(
                //   child:
                //   // PaginateFirestore(
                //   //itemBuilderType: PaginateBuilderType.listView,
                //   // header:
                //
                //
                //   //   itemBuilder: (context, document,index) {
                //   //     final data = document[index].data() as Map;
                //   //},
                //
                //
                //   onRefresh: () async {
                //     refreshedChangeListener.refreshed = true;
                //   },
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
