import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:grocery_project/module/Customer_Side/services/user_services.dart';

class ProfileUpdate extends StatefulWidget {
  static const String id = "profile-update-screen";

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserServices _userServices = UserServices();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  var txtMobile = TextEditingController();
  bool mobile = false;
  @override
  void initState() {
    _userServices.getUserData(user!.uid).then((value) {
      if (mounted) {
        setState(() {
          mobile = value["mobile"];
          print(mobile);
          txtFirstName.text = value["firstName"];
          txtEmail.text = value["email"];
          txtMobile.text = value['number'] != null ? value['number'] : " ";
        });
      }
    });
    super.initState();
  }


  updateProfile() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({
      'firstName': txtFirstName.text,
      'lastName': "",
      'email': txtEmail.text,
      'number': txtMobile.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  cursorColor: Colors.green,
                  controller: txtFirstName,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    labelText: "First Name ",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " Enter full name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                TextFormField(
                  readOnly: mobile,
                  cursorColor: Colors.green,
                  controller: txtMobile,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    labelText: "Mobile ",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                TextFormField(
                  readOnly: !mobile,
                  cursorColor: Colors.green,
                  controller: txtEmail,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " Enter Email Address";
                    } else if (validateEmail(txtEmail.text.trim()) != null) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: "Updating Profile...");
                      updateProfile().then((value) {
                        EasyLoading.showSuccess("Profile Updated");
                        Get.back();
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }
}
