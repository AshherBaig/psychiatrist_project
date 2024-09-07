import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/widgets/custom_text_style.dart';

class CustomWidgets{

  static showConfirmDialogWithActions(
      BuildContext context,
      String msg,
      String yesText,
      String noText,
      VoidCallback onYesPressed,
      VoidCallback onNoPressed)
  {
    // set up the buttons
    Widget continueButton = MaterialButton(
        padding: EdgeInsets.all(5),
        color: Colors.green,
        child: Center(
          child: Text(yesText,
              style:
              CustomTextStyle.getStyle(FontWeight.w500, 10, Colors.white)),
        ),
        onPressed: () {
          Get.back();
          onYesPressed();
        });

    Widget noButton = MaterialButton(
        padding: EdgeInsets.all(5),
        color: Colors.red,
        child: Center(
          child: Text(noText,
              style:
              CustomTextStyle.getStyle(FontWeight.w500, 10, Colors.white)),
        ),
        onPressed: () {
          Get.back();
          onNoPressed();
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      content: Text(msg,
          style:
          CustomTextStyle.getStyle(FontWeight.normal, 12, Colors.black)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [noButton, continueButton],
        ),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}