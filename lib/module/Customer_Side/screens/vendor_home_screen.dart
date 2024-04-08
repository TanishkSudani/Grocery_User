import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/categories_widget.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/bestSelling_product.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/featured_product.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/vendorAppBar.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/vendor_banner.dart';
import 'package:grocery_project/module/Customer_Side/utils/product/recentalyAdded_product.dart';
class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-home-screen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              vendorHomeAppBar(),
            ];
          },
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(height: size.height/40,),
              VendorBanner(),
              Categories(),
              SizedBox(height: size.height/40,),
              FeaturedProduct(),
              SizedBox(height: size.height/40,),
              BestSellingProduct(),
              SizedBox(height: size.height/50,),
              RecentlyAdded(),
              SizedBox(height: 60,)
            ],
          ),
        ),
      ),
    );
  }
}
