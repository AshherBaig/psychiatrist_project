import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:psychiatrist_project/widgets/app_color.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final Color? iconColor;
  const SocialButton(
      {super.key, required this.onTap, required this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 29,
        width: 29,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.kLightWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 32,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(0.25))
            ]),
        child: SvgPicture.asset(
          icon,
          width: 100.0,
          height: 100.0,
          color: iconColor,
        ),
      ),
    );
  }
}
