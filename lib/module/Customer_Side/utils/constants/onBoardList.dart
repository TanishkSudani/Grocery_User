import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class onBoardList {
  onBoardList._();

  static int currentPageIndex = 0;
  static const onBoardPageStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );
  static List<Widget> pages = [
    Column(
      children: [
        Expanded(
          child: Container(
            width: 300,
            child: Lottie.asset("assets/lottie/location.json"),
          ),
        ),
        Text(
          'Set Your Delivery Location',
          style: onBoardPageStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
    Column(
      children: [
        Expanded(child: Lottie.asset('assets/lottie/shopping.json')),
        Text(
          'Order online from your favourite store',
          style: onBoardPageStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
    Column(
      children: [
        Expanded(child: Lottie.asset('assets/lottie/delivery.json')),
        Text(
          'Quick delivery',
          style: onBoardPageStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ];
}
