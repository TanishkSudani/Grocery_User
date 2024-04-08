import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/screens/map_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/my_order_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/profile_update_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/welcome_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = "profile-screen";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var userDetails = Provider.of<AP>(context);
    var locationData = Provider.of<LocationProvider>(context);
    userDetails.getUserDetails();
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(onTap: (){Get.back();},child: Icon(CupertinoIcons.back,color: Colors.white,)),
          backgroundColor: Colors.green,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Grocify",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 40,
                    ),
                    Text(
                      " Manage My Profile :",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.40),
                        )
                      ],
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                //child: FaIcon(FontAwesomeIcons.user,color: Colors.green,),
                                backgroundImage: NetworkImage("${userDetails.snapshot?["imageUrl"]}")
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userDetails.snapshot!.data() != ""
                                          ? "${userDetails.snapshot?["firstName"]}"
                                          : " Update Your Name",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      userDetails.snapshot!.data() != ""
                                          ? "${userDetails.snapshot?["number"]}"
                                          : "update mobile number",
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: size.height/50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (userDetails.snapshot?["email"] != null)
                                      Flexible(
                                        child: Container(
                                          width: size.width/1.7,
                                        //  color: Colors.red,
                                          child: Text(
                                            userDetails.snapshot != ""
                                                ? "${userDetails.snapshot?["email"]}"
                                                : 'Email',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(

                                              fontSize: size.width/25, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (userDetails.snapshot?["location"] != null)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(userDetails.snapshot?["location"]),
                                subtitle: Text(
                                  userDetails.snapshot?["address"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.zero,
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: Colors.redAccent))),
                                    ),
                                    onPressed: () {
                                      EasyLoading.show(
                                          status: "Please wait....");
                                      locationData
                                          .getCurrentPosition()
                                          .then((value) {
                                        if (value != null) {
                                          EasyLoading.dismiss();
                                          pushNewScreenWithRouteSettings(
                                            context,
                                            screen: MapScreen(),
                                            settings: RouteSettings(
                                                name: MapScreen.id),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                        } else {
                                          EasyLoading.dismiss();
                                          log("Permission not allowed");
                                          Get.toNamed(MapScreen.id);
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Change",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      right: 10,
                      child: IconButton(
                          onPressed: () {
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: ProfileUpdate.id),
                              screen: ProfileUpdate(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          )))
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.to(MyOrderScreen());
                },
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text(" MY Orders"),
                  horizontalTitleGap: 2,
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text("  Logout"),
                horizontalTitleGap: 2,
                onTap: () async {
                  Get.offNamed(WelcomeScreen.id);
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: WelcomeScreen.id),
                    screen: WelcomeScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  // await FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(user!.uid)
                  //     .delete();
                  FirebaseAuth.instance.signOut();
                  log("===============>>>>>>>>>>>>> LogOUT");
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
