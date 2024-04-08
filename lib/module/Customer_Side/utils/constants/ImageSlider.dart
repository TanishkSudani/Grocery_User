import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late Stream<QuerySnapshot> imageStream;
  CarouselController carouselController = CarouselController();
  int index = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("slider").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: imageStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length > 1) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
                            sliderImage['img'],
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
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
