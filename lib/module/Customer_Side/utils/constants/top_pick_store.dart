import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/screens/vendor_home_screen.dart';
import 'package:grocery_project/module/Customer_Side/services/store_services.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatefulWidget {
  @override
  State<TopPickStore> createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {


  @override
  Widget build(BuildContext context) {
    StoreServices storeServices = StoreServices();
    final size = MediaQuery.of(context).size;
    final storeData = Provider.of<StoreProvider>(context);
    storeData.getUserLocationData(context);
    String getDistance(location) {
      var distance = Geolocator.distanceBetween(
          storeData.userLatitude, storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: storeServices.getTopPikedStore(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child:  Lottie.asset('assets/lottie/loading.json'),
            );
          List shopDistance = [];
          for (int i = 0; i <= snapshot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                storeData.userLatitude, storeData.userLongitude,
                snapshot.data!.docs[i]["shopLocation"].latitude,
                snapshot.data!.docs[i]["shopLocation"].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
            shopDistance.sort();
            if (shopDistance[0] > 10) {
              return Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                height: size.height / 10,
                child: Center(
                  child: Text(
                    "Currently we are not servicing in your area,Please try later or try another location.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          }
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      FaIcon(FontAwesomeIcons.thumbsUp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Top Picks For You",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      if (double.parse(getDistance(document["shopLocation"])) <=
                          10) {
                        return InkWell(
                          onTap: () {
                            storeData.getSelectedStore(document,getDistance(document["shopLocation"]));
                            pushNewScreenWithRouteSettings(
                              context,
                              settings:
                                  RouteSettings(name: VendorHomeScreen.id),
                              screen: VendorHomeScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              width: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Here Put Image
                                  Container(
                                    height: 70,
                                    width: 140,
                                    decoration: BoxDecoration(
                              //      color: Colors.red,
                                      image: DecorationImage(
                                        image:  NetworkImage(
                                          document["shopImage"],
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  //Name
                                  Text(
                                    "${document["shopName"]}",
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${getDistance(document["shopLocation"])}km",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
