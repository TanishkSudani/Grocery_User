import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_project/module/Customer_Side/screens/loginScreen.dart';
import 'package:grocery_project/module/Customer_Side/screens/main_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = "map-screen";

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = LatLng(21.239745, 72.847058);
  late GoogleMapController mapController;
  TextEditingController locationController = TextEditingController();
  bool _locating = false;
  String? featureName = "";
  String? addressLine = "";
  bool loggedin = false;
  User? user = FirebaseAuth.instance.currentUser;
  double latitude = 0;
  double longitude = 0;
  String add = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    if (user != null) {
      setState(() {
        loggedin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AP>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });
    void onCreated(GoogleMapController controller) {
      setState(() {
        mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: currentLocation, zoom: 14.4746),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMoved(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: size.height / 16,
                margin: EdgeInsets.only(bottom: size.height / 20),
                child: Image.asset("assets/images/mapPin.png"),
              ),
            ),
            Center(
              child: SpinKitPulse(
                color: Colors.green,
                size: 100.0,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 200,
                width: size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locating
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            )
                          : Container(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_searching,
                          color: Colors.green,
                        ),
                        label: _locating
                            ? Text(
                                "Locating....",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              )
                            : locationData == null
                                ? Text(
                                    "Locating....",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                : Text(
                                    "${locationData.featureName}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.green),
                                  ),
                      ),
                      Text(
                        _locating
                            ? ""
                            : locationData == null
                                ? ""
                                : locationData.addressLine,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: size.height / 50,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.height / 80,
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   height: size.height / 13,
                      //   width: size.width,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: Color(0xffe1e1e1),
                      //   ),
                      //   child: TextFormField(
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return "Please Enter Location";
                      //       } else {
                      //         return null;
                      //       }
                      //     },
                      //     onTap: () {
                      //       locationController.text =
                      //           locationData.addressLine.toString();
                      //     },
                      //     controller: locationController,
                      //     keyboardType: TextInputType.streetAddress,
                      //     cursorColor: Color(0xff26a601),
                      //     decoration: InputDecoration(
                      //       contentPadding:
                      //           const EdgeInsets.fromLTRB(20, 20, 15, 15),
                      //       errorBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         borderSide: BorderSide(
                      //           color: Colors.red,
                      //         ),
                      //       ),
                      //       hintText: 'Enter Your Full Location',
                      //       hintStyle: TextStyle(
                      //         color: Color(0xff939292),
                      //         fontFamily: 'Poppins',
                      //       ),
                      //       border:
                      //           OutlineInputBorder(borderSide: BorderSide.none),
                      //       prefixIcon: Icon(
                      //         Icons.location_on_outlined,
                      //         color: Colors.green,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: size.height / 60,
                      ),
                      AbsorbPointer(
                        absorbing: _locating ? true : false,
                        child: GestureDetector(
                          onTap: () {
                            add = locationData.addressLine.toString();
                            latitude = locationData.latitude;
                            longitude = locationData.longitude;
                            //Save Location Here......
                            locationData.savePrefs();
                            if (loggedin == false) {
                              Get.toNamed(LoginScreen.id);
                            } else {
                              setState(() {
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address = locationData.addressLine;
                                auth.location = locationData.featureName;
                              });
                              auth
                                  .updateUser(
                                id: user!.uid,
                                number: user!.phoneNumber.toString(),
                              )
                                  .then((value) {
                                if (value == true) {
                                  Get.toNamed(MainScreen.id);
                                }
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width,
                            height: size.height / 20,
                            decoration: BoxDecoration(
                              color: _locating ? Colors.grey : Colors.green,
                              borderRadius:
                                  BorderRadius.circular(size.height / 100),
                            ),
                            child: Text(
                              "Confirm Location",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
