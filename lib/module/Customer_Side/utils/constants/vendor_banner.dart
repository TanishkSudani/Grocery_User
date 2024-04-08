import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/store_provide.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {
  const VendorBanner({super.key});

  @override
  State<VendorBanner> createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {
  late Stream<QuerySnapshot> imageStream;
  CarouselController carouselController = CarouselController();
  int index = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    var firebase = FirebaseFirestore.instance;
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: firebase
          .collection("vendorBanner")
          .where('sellerUid', isEqualTo: _storeProvider.storeDetails?["shopId"])
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length > 1) {
          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              children: [
                Container(
                  width: size.width/1.1,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index, ___) {
                        DocumentSnapshot sliderImage = snapshot.data!.docs[index];
                        return SizedBox(
                          width: size.width,
                          child: Image.network(
                            sliderImage['imageUrl'],
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                      options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          initialPage: 0,
                          height: size.height / 5,
                          onPageChanged: (int i, carouselPageChangeReason) {
                            setState(() {
                              index = i;
                            });
                          }),
                    ),
                  ),
                ),
                DotsIndicator(
                  dotsCount: snapshot.data!.docs.length,
                  position:
                      index > snapshot.data!.docs.length ? index = 0 : index,
                  decorator: DotsDecorator(
                    size: Size.square(size.height / 100),
                    activeSize: Size(size.width / 40, size.height / 80),
                    color: Colors.grey,
                    // Inactive color
                    activeColor: Colors.green,
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Container(),
          );
        }
      },
    );
  }
}
