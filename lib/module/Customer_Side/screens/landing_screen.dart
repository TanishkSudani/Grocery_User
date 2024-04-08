import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/screens/map_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-Screen';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delivery address is not set',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please update your location to find nearest stores for you',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 600,
                child: Image.asset(
                  "assets/images/city.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              _loading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  : GestureDetector(
                      onTap: () async {
                        setState(() {
                          _loading = true;
                        });
                        await _locationProvider.getCurrentPosition();
                        if (_locationProvider.permissionAllowed == true) {
                          Get.offNamed(MapScreen.id);
                        } else {
                          Future.delayed(Duration(seconds: 4), () {
                            if (_locationProvider.permissionAllowed == false) {
                              log("Permission Not Allowed");
                              setState(() {
                                _loading = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Please allow permission to find nearest store for you."),
                                  ),
                                );
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width/2,
                        height: size.height / 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.circular(size.height / 100),
                        ),
                        child: Text(
                          "Set Your Location",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
