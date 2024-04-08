import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/utils/constants/onBoardList.dart';


class onBoardUIScreen extends StatefulWidget {
  const onBoardUIScreen({super.key});

  @override
  State<onBoardUIScreen> createState() => _onBoardUIScreenState();
}

final pageController = PageController(
  initialPage: 0,
);

class _onBoardUIScreenState extends State<onBoardUIScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: onBoardList.pages,
              onPageChanged: (index) {
                setState(() {
                  onBoardList.currentPageIndex = index;
                });
              },
            ),
          ),
          SizedBox(
            height: size.height / 80,
          ),
          DotsIndicator(
            dotsCount: onBoardList.pages.length,
            position: onBoardList.currentPageIndex,
            decorator: DotsDecorator(
              size: Size.square(size.height/100),
              activeSize: Size(size.height/40,size.width/45),
              color: Colors.grey, // Inactive color
              activeColor: Colors.green,
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
            ),
          ),
          SizedBox(height: size.height/30,),
          Text("Ready to order from your nearest shop?"),
          SizedBox(
            height: size.height / 25,
          ),
        ],
      ),
    );
  }
}
