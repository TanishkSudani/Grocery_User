import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SaveForLater extends StatelessWidget {
  final DocumentSnapshot document;
  SaveForLater(this.document);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EasyLoading.show(status: 'Saving....');
        saveForLater().then((value) {
          EasyLoading.showSuccess("Saved successfully");
        });
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20)
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.heart,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Text(
                  "Add to Favourite",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> saveForLater() {
    User? user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance.collection("favourites").add(
      {
        'product' : document.data(),
        'customerId' : user!.uid,
      },
    );
  }
}
