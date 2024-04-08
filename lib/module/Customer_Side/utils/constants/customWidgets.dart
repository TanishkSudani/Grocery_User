import 'package:flutter/material.dart';
import 'package:get/get.dart';

class customWidget {
  customWidget._();

  static void customModelSheet(context, Widget) {
    showModalBottomSheet(context: context, builder: (context) => Widget);
  }

  static customSnackbar({
    required suberrorTitle,
    required errorTitle,
    required icon,
    required iconColor,
    required errorTitleColor,
    required backgroundColor,
  }) {
    return Get.snackbar(
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            '${errorTitle}',
            style: TextStyle(
                color: errorTitleColor, fontSize: 25, fontFamily: 'Poppins'),
          )
        ],
      ),
      '',
      "${suberrorTitle}",
      backgroundColor: backgroundColor,
    );
  }
}
