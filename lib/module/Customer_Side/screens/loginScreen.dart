import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/provider/auth_provider.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login-screen";
  // double latitude = 0;
  // double longitude = 0;
  // String add = "";

  LoginScreen(
      {super.key,
      // required this.latitude,
      // required this.longitude,
      // required this.add
      });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  bool _validPhoneNumber = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AP>(context);
    final locationData = Provider.of<LocationProvider>(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              height: size.height / 1.5,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height / 50,
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
                      height: size.height / 20,
                    ),
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
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(width: size.width/20,),
                        Text(
                          '---------  Or  ---------',
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
                            autofocus: true,
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
                                setState(() {
                                  _validPhoneNumber = true;
                                });
                              } else {
                                setState(() {
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
                                  borderSide: BorderSide.none),
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
                            setState(() {
                              auth.loading = true;
                              auth.screen = "MapScreen";
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.address = locationData.addressLine;
                            });
                            String number = "+91${phoneController.text}";
                            auth
                                .verifyPhone(
                                    context: context,
                                    number: number,
                                    )
                                .then((value) => () {
                                      phoneController.clear();
                                      setState(() {
                                        auth.loading = false;
                                      });
                                    });
                          } else {
                            Get.snackbar('Alert', 'Enter valid phone number',
                                snackPosition: SnackPosition.TOP);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width,
                          height: size.height / 20,
                          decoration: BoxDecoration(
                            color:
                                _validPhoneNumber ? Colors.green : Colors.grey,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
