import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/screens/map_screen.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/onBoardUI.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome-screen";

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController phoneController = TextEditingController();
  bool _validPhoneNumber = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AP>(context);
    final size = MediaQuery.of(context).size;
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter myState) {
              return AnimatedContainer(
                duration: Duration(seconds:1),
                height: size.height / 1.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'LOGIN WITH US',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 100,
                        ),
                        Row(
                          children: [
                            //SizedBox(width: size.width/20,),
                            Text(
                              'We need to verify you. We will send you a one\n time verification code.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939292),
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                auth.googleLogin();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height / 15,
                                width: size.width / 1.1,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 12,
                                      color: Color.fromRGBO(0, 0, 0, 0.20),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //FaIcon(FontAwesomeIcons.google,color: Colors.green,),
                                    Container(
                                        height: size.height / 5,
                                        width: size.width / 10,
                                        child: Image.asset(
                                            "assets/images/google.png"),),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Login with Google",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //SizedBox(width: size.width/20,),
                            Text(
                              'Or',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939292),
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: size.height / 13,
                              width: size.width / 1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffe1e1e1),
                              ),
                              child: TextFormField(
                                //   autofocus: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Mobile Number Can't be Empty";
                                  } else if (!RegExp(r"^^[0-9]*$")
                                      .hasMatch(value)) {
                                    return "Enter Correct Mobile Number";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    myState(() {
                                      _validPhoneNumber = true;
                                    });
                                  } else {
                                    myState(() {
                                      _validPhoneNumber = false;
                                    });
                                  }
                                },
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                cursorColor: Color(0xff26a601),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 20, 15, 15),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                  hintText: 'Enter Phone Number',
                                  hintStyle: TextStyle(
                                    color: Color(0xff939292),
                                    fontFamily: 'Poppins',
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                  suffixIcon: _validPhoneNumber
                                      ? Icon(
                                          Icons.check,
                                          color: Color(0xff26a601),
                                          size: 30,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height / 40,
                        ),
                        AbsorbPointer(
                          absorbing: _validPhoneNumber ? false : true,
                          child: GestureDetector(
                            onTap: () {
                              if (phoneController.text.length == 10) {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number = "+91${phoneController.text}";
                                auth
                                    .verifyPhone(
                                        context: context, number: number)
                                    .then((value) => () {
                                          phoneController.clear();
                                          setState(() {
                                            auth.loading = false;
                                          });
                                        });
                              } else {
                                Get.snackbar(
                                    'Alert', 'Enter valid phone number',
                                    snackPosition: SnackPosition.TOP);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              height: size.height / 20,
                              decoration: BoxDecoration(
                                color: _validPhoneNumber
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(size.height / 100),
                              ),
                              child: auth.loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      _validPhoneNumber
                                          ? "Continue"
                                          : "Enter Phone Number",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height / 5,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ).whenComplete(() {
        auth.loading = false;
        phoneController.clear();
      });
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: size.height / 30),
        child: Stack(
          children: [
            Positioned(
              top: size.height / 180,
              right: size.width / 35,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    auth.screen = "bottom sheet login";
                  });
                  showBottomSheet(context);
                },
                child: Text(
                  "SKIP",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Expanded(
                  child: onBoardUIScreen(),
                ),
                GestureDetector(
                  onTap: () async {
                    Geolocator.openAppSettings();
                    setState(() {
                      locationData.loading = true;
                    });
                    await locationData.getCurrentPosition();
                    if (locationData.permissionAllowed == true) {
                      Get.offNamed(MapScreen.id);
                      setState(() {
                        locationData.loading = false;
                      });
                    } else {
                      Geolocator.openAppSettings();
                      log("Permission Not allowed...");
                      setState(() {
                        locationData.loading = false;
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height / 23,
                    width: size.width / 2,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(size.height / 30),
                    ),
                    child: Text(
                      "Set Delivery Location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ), //Set Location Button
                TextButton(
                  onPressed: () {
                    setState(() {
                      auth.screen = "bottom sheet login";
                    });
                    showBottomSheet(context);
                  },
                  child: Text(
                    'Already a Customer? Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
