import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final SnackBarAction? action;

  const CustomSnackBar({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      action: action,
    );
  }
}