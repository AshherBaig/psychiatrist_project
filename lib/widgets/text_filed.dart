import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/widgets/app_color.dart';

class AuthField extends StatelessWidget {
  final void Function(String)? onChanged;
  final String icon;
  final Color iconColor;
  final String hintText;
  bool isObscure;
  bool isSuffixIcon;
  IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AuthController _authController = Get.find<AuthController>();
  AuthField(
      {super.key,
      required this.iconColor,
      required this.onChanged,
      required this.icon,
      this.isObscure = false,
      this.isSuffixIcon = false,
      this.suffixIcon,
      required this.hintText,
      this.validator,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      keyboardType: keyboardType,
      decoration: InputDecoration(
          suffixIcon: isSuffixIcon ? IconButton(onPressed: () {
            _authController.isObscure.value = !_authController.isObscure.value;
          }, icon: Icon(suffixIcon)) : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          fillColor: AppColors.kLightWhite2,
          filled: true,
          errorMaxLines: 3,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: iconColor),
              child: SvgPicture.asset(
                icon,
                width: 50.0,
                height: 50.0,
              ),
            ),
          )),
    );
  }
}
