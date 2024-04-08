import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/customWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 21.239745;
  double longitude = 72.847058;
  bool permissionAllowed = false;
  String featureName = "";
  String addressLine = "";
  bool loading = true;

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LocationPermission permission = await Geolocator.checkPermission();
    if (position != null ||
        permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      this.permissionAllowed = true;
      notifyListeners();
    } else {
      log("permission Not allowed");
      customWidget.customSnackbar(
        suberrorTitle: "Permission is not allowed",
        errorTitle: "Allow",
        icon: Icons.location_on_outlined,
        iconColor: Colors.white,
        errorTitleColor: Colors.white,
        backgroundColor: Colors.green,
      );
    }
    return position;
  }

  void onCameraMoved(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.featureName = address.first.featureName.toString();
    notifyListeners();
    this.addressLine = address.first.addressLine.toString();
    log("~~~>>> ${this.featureName} : ${this.addressLine}");
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('latitude', this.latitude);
    prefs.setDouble('longitude', this.longitude);
    prefs.setString('address', this.addressLine);
    prefs.setString('location', this.featureName);
  }
}
