import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/screens/home.dart';
import 'package:grocery_project/module/Customer_Side/screens/profile_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/welcome_screen.dart';
import 'package:grocery_project/module/Customer_Side/services/user_services.dart';


class StoreProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;
  String selectedStore = "";
  String selectedStoreId = "";
  DocumentSnapshot? storeDetails;
  String distance = "";
  String selectedCategory = "";
  String? selectedSubCategory = "";

  getSelectedStore(storeDetails,distance) {
   this.storeDetails = storeDetails;
   this.distance = distance;
    notifyListeners();
  }
  getSelectedCategory(category) {
   this.selectedCategory = category;
    notifyListeners();
  }
  getSelectedSubCategory(subCategory) {
   this.selectedSubCategory = subCategory;
    notifyListeners();
  }

  Future<void> getUserLocationData(BuildContext context) async {
    _userServices.getUserData(user!.uid).then((result) {
      if (result != null) {
        this.userLatitude = result["latitude"];
        this.userLongitude = result["longitude"];
        notifyListeners();
      } else {
        Get.offNamed(WelcomeScreen.id);
      }
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}
