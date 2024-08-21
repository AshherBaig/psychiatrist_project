import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:psychiatrist_project/Patient/auth/signUpScreen.dart';
import 'package:psychiatrist_project/widgets/app_color.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTapBtn;
  final String text;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? btnColor;
  final Color? fontColor;
  const PrimaryButton(
      {super.key,
      required this.onTapBtn,
      required this.text,
      this.height,
      this.width,
      this.fontSize,
      this.btnColor,
      this.fontColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBtn,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: btnColor ?? AppColors.kPrimary,
            borderRadius: BorderRadius.circular(23)),
        child: Text(
          text,
          style: TextStyle(
              color: fontColor ?? AppColors.kLightWhite,
              fontSize: fontSize ?? 20),
        ),
      ),
    );
  }
}
