import 'package:cloud_firestore/cloud_firestore.dart';

class favProduct
{
  CollectionReference fav = FirebaseFirestore.instance.collection("favourites");
  delete() async{
    fav.doc().collection("favourites").get().then((snapShot) {
      for (DocumentSnapshot ds in snapShot.docs) {
        ds.reference.delete();
      }
    });
  }
}