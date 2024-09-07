import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle appBar() {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      // fontFamily: FONT_Inter,
      color: Color(0xffFFFFFF),
    );
  }

  static TextStyle getStyle(FontWeight weight, double fontSize, Color color,
      {bool underline = false}) {
    return TextStyle(
        fontWeight: weight,
        fontSize: 16,
        // fontFamily: FONT_NAME,
        decoration: underline ? TextDecoration.underline : null,
        color: color);
  }

  static TextStyle button16(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16,
        // fontFamily: FONT_NAME,
        color: Colors.white);
  }

  static Padding buttonStyle(BuildContext context, String label) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              decoration: buttonDecoration(context),
              width: MediaQuery.of(context).size.width - 30,
              height: 45,
              child: Center(
                child: Text(label,
                    textAlign: TextAlign.center, style: button16(context)),
              )),
        ));
  }

  static BoxDecoration buttonDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor,
      border: Border.all(
        width: 1, //
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
  }
}