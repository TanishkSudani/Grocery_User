import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_project/module/Customer_Side/provider/location_provider.dart';
import 'package:grocery_project/module/Customer_Side/screens/landing_screen.dart';
import 'package:grocery_project/module/Customer_Side/screens/main_screen.dart';
import 'package:grocery_project/module/Customer_Side/services/user_services.dart';

import 'dart:developer';
import 'package:pinput/pinput.dart';

class AP with ChangeNotifier {
  String? smsOtp;
  String? verificationId;
  String error = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  UserServices userServices = UserServices();
  bool loading = false;
  String screen = "";
  LocationProvider locationProvider = LocationProvider();
  double? latitude;
  double? longitude;
  String? address;
  String? location;
  DocumentSnapshot? snapshot;
  String? photoUrl;

  Future<void> googleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken:  googleSignInAuthentication.idToken,
      );
      try{

        UserCredential userCredential = await auth.signInWithCredential(credential);
        User? user = userCredential.user;
        log(user?.uid ?? "");
        log(user?.email ?? "");
        log(user?.phoneNumber ?? "");
        log(user?.photoURL ?? "");
        log(user?.displayName ?? "");
        photoUrl = user?.photoURL;
        notifyListeners();
        userServices.getUserData(user!.uid).then((ss) {
          if (ss.exists) {
            //User Data already Exists
            if (this.screen == "bottom sheet login") {
              if (ss['address'] != null) {
                Get.offNamed(MainScreen.id);
              } else {
                Get.offNamed(LandingScreen.id);
              }
            } else {
              updateUser(
                id: user.uid,
                number: user.phoneNumber.toString(),
              );
              Get.offNamed(MainScreen.id);
              log("===============>>>>>>>>>>>>> User Updated");
            }
          } else {
            //User Data Doesn't Exists
            createUser(
              mobile: false,
              id: user.uid,
              number: user.phoneNumber.toString(),
              email: user.email,
              firstName: user.displayName,
              imageUrl: user.photoURL,
            );
            //Get.toNamed(LandingScreen.id);
            Get.offNamed(MainScreen.id);
            log("===============>>>>>>>>>>>>> User Created");
          }
        });

      } on FirebaseAuthException catch(e){
        log("Firebase google error${e.message ?? " "}");
      } catch (e){
        log("eeeeeee ${e.toString()}");
      }
    }
  }

  Future<void> verifyPhone({
    BuildContext? context,
    String? number,
  }) async {
    this.loading = true;
    notifyListeners();
    smsOtpDialog(context!, number!);
    try {
      auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          this.loading = false;
          notifyListeners();
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          this.loading = false;
          this.error = exception.toString();
          notifyListeners();
          print("~~>> OTP Error ${exception.code.toString()}");
        },
        codeSent: (String verificationID, int? resendToken) async {
          log("otp sent......................................................");
          this.verificationId = verificationID;
        },
        codeAutoRetrievalTimeout: (String value) {},
      );
    } on FirebaseAuthException catch (authException) {
      this.error = authException.toString();
      this.loading = false;
      notifyListeners();
      log("~~>> FirebaseAuthException ${authException.code}");
    }
  }

  final focusedBorderColor = Color.fromRGBO(0, 180, 49, 1.0);
  final fillColor = Color.fromRGBO(243, 246, 249, 0);

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Colors.green),
    ),
  );

  Future smsOtpDialog(BuildContext context, String number) {
    final size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Code',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(
                  height: size.height / 200,
                ),
                Text(
                  'Enter 6 digit OTP received as sms',
                  style:
                      TextStyle(fontSize: size.height / 60, color: Colors.grey),
                ),
              ],
            ),
            content: Container(
              height: size.height / 18,
              width: size.width / 5,
              color: Colors.transparent,
              child: Pinput(
                length: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                hapticFeedbackType: HapticFeedbackType.mediumImpact,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: size.width / 40,
                      height: 1,
                      color: Colors.green,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    final PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId!,
                      smsCode: smsOtp!,
                    );
                    User? user =
                        (await auth.signInWithCredential(credential)).user;
                    if (user != null) {
                      this.loading = false;
                      notifyListeners();
                      userServices.getUserData(user.uid).then((ss) {
                        if (ss.exists) {
                          //User Data already Exists
                          if (this.screen == "bottom sheet login") {
                            //need to check user data already exists in db or not
                            //if its 'login' no new data,no update
                            if (ss['address'] != null) {
                              Get.offNamed(MainScreen.id);
                            } else {
                              Get.offNamed(LandingScreen.id);
                            }
                          } else {
                            updateUser(
                              id: user.uid,
                              number: user.phoneNumber.toString(),
                            );
                            Get.offNamed(MainScreen.id);
                            log("===============>>>>>>>>>>>>> User Updated");
                          }
                        } else {
                          //User Data Doesn't Exists
                          createUser(
                            mobile: true,
                            id: user.uid,
                            number: user.phoneNumber.toString(),
                          );
                          //Get.toNamed(LandingScreen.id);
                          Get.offNamed(MainScreen.id);
                          log("===============>>>>>>>>>>>>> User Created");

                        }
                      });
                    } else {
                      log("===============>>>>>>>>>>>>>Login Failed");
                    }
                  } on FirebaseException catch (e) {
                    this.error = "Invalid Otp";
                    Get.snackbar(
                        titleText: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: size.width / 60,
                            ),
                            Text(
                              'Warning',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height / 40,
                                  fontFamily: 'Poppins'),
                            )
                          ],
                        ),
                        '',
                        "${this.error}",
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                    notifyListeners();
                    print("~~>> ${e.toString()}");
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void createUser({required String id, required String number,String? firstName,String? email ,String? imageUrl,required bool mobile}) {
    userServices.createUserData({
      'id': id,
      'number': number != null ? number : "",
      'firstName': firstName != null ? firstName : "",
      'lastName': "",
      'email': email != null ? email : "",
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location,
      'mobile': mobile,
      'imageUrl': imageUrl != null ? imageUrl : "https://firebasestorage.googleapis.com/v0/b/grocery-app-980ba.appspot.com/o/user.png?alt=media&token=f242eaf7-6061-4a10-9022-8e4b3262b664",
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    required String id,
    required String number,
  }) async {
    try {
      userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location,
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      log("error+++++++++++++++++++${e}");
      return false;
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();
    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      this.snapshot = null;
      notifyListeners();
    }
    return result;
  }
}
