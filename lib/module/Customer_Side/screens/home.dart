import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_project/module/Customer_Side/screens/generate_recipe.dart';
import 'package:grocery_project/module/Customer_Side/screens/my_order_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/profile_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/welcome_screen.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/ImageSlider.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/myAppBar.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/near_by_store.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/top_pick_store.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AP>(context);
    userDetails.getUserDetails();
    User? user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Grocify",
            style: GoogleFonts.dancingScript(
                fontWeight: FontWeight.w600, color: Colors.white, fontSize: 30),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(GenerateRecipe.id);
                },
                icon: Icon(Icons.local_restaurant)),
            IconButton(
              onPressed: () {
                Get.to(MyOrderScreen());
              },
              icon: Icon(CupertinoIcons.cart),
            ),
            SizedBox(
              width: size.width / 20,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 40,
                    backgroundImage: NetworkImage("${userDetails.snapshot?["imageUrl"]}"),
                  backgroundColor: Colors.white,
                ),
                accountEmail:  Text(
                  userDetails.snapshot != null
                      ? "${userDetails.snapshot?["email"]}"
                      : 'Email',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white),
                ),
                accountName: Text(
                  "${userDetails.snapshot?["firstName"]}" == "" ?
                  "${user?.phoneNumber}" :"${userDetails.snapshot?["firstName"]}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),

              ListTile(
                leading: const Icon(CupertinoIcons.cart,color: Colors.green,),
                title: const Text(
                  'Cart',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Get.to(MyOrderScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_restaurant,color: Colors.green,),
                title: const Text(
                  'Cook with us',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Get.toNamed(GenerateRecipe.id);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.person_circle,color: Colors.green,),
                title: const Text(
                  'Profile',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Get.toNamed(ProfileScreen.id);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.power,color: Colors.green,),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () async{
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: WelcomeScreen.id),
                    screen: WelcomeScreen(),
                    withNavBar: false,
                    pageTransitionAnimation:
                    PageTransitionAnimation.cupertino,
                  );
                  FirebaseAuth.instance.signOut();
                  log("===============>>>>>>>>>>>>> LogOUT");
                },
              ),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              MyAppBar(),
            ];
          },
          body: ListView(
            children: [
              ImageSlider(),
              Container(
                height: size.height / 5.1,
                width: size.width/4,
                child: TopPickStore(),
              ),
              NearByStore(),
            ],
          ),
        ),
      ),
    );
  }
}
