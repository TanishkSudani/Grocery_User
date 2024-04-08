
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:grocery_project/module/Customer_Side/services/product_service.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  const ProductFilterWidget({super.key});

  @override
  State<ProductFilterWidget> createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  productService _service = productService();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var _store = Provider.of<StoreProvider>(context);
    FirebaseFirestore.instance
        .collection('products')
        .where("category.mainCategory", isEqualTo: _store.selectedCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _subCatList.add(doc["category"]["subCategory"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return FutureBuilder<DocumentSnapshot>(
      future: _service.category.doc(_store.selectedCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return Container();
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Container(
            height: 50,
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 6),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  ActionChip(
                    side: BorderSide.none,
                    color: MaterialStateProperty.all(Colors.green.shade200),
                    shape: RoundedRectangleBorder(
                      // side: BorderSide.none,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 4,
                    label: Text(" All ${_store.selectedCategory} "),
                    onPressed: () {
                      _store.getSelectedSubCategory(null);
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length >= 10 ? 10 : data.length - 1,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int item) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10,),
                        child: _subCatList
                                .contains(data["subCat"][item]["subCatName"])
                            ? ActionChip(
                         // side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                elevation: 4,
                                label:
                                    Text(data.isNotEmpty ? "${data["subCat"][item]["subCatName"]}" : ""),
                                onPressed: () {
                                  _store.getSelectedSubCategory(
                                      data["subCat"][item]["subCatName"]);
                                },
                              )
                            : Container(),
                      );
                    },
                  )
                ],
              ),
            )
            // ListView(
            //   padding: EdgeInsets.zero,
            //   scrollDirection: Axis.horizontal,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 6.0, right: 2),
            //       child: Chip(
            //         backgroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         label: Text("Sub Category"),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 6.0, right: 2),
            //       child: Chip(
            //         backgroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         label: Text("Sub Category"),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 6.0, right: 2),
            //       child: Chip(
            //         backgroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         label: Text("Sub Category"),
            //       ),
            //     ),
            //   ],
            // ),
            );
      },
    );
  }
}
