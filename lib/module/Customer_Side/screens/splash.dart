import 'dart:async';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_project/module/Customer_Side/screens/landing_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/main_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/welcome_screen.dart';
import 'package:grocery_project/module/Customer_Side/services/user_services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash-screen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Get.offNamed(WelcomeScreen.id);
        } else {
          getUserData();
        }
      });
    });
  }

  getUserData() async {
    UserServices _userServices = UserServices();
    _userServices.getUserData(user!.uid).then((result) {
      if (result['address'] != null) {
        updatePrefs(result);
        Get.offNamed(MainScreen.id);
        log("here goes.......");
      } else {
        Get.offNamed(MainScreen.id);
        log("here goes....... Won");
      }
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);

    Get.toNamed(MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height / 4,
              width: size.width,
              child: Lottie.asset('assets/lottie/shoppingBag.json'),
            ),
            AnimatedTextKit(animatedTexts: [ScaleAnimatedText(duration: Duration(seconds: 4),"Grocify", textStyle: TextStyle(fontSize: 60,color:Colors.green,fontFamily: "Poppins"),)])
          ],
        ),
      ),
    );
  }
}
