import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/Patient/controllers/authController.dart';
import 'package:psychiatrist_project/Patient/patientScreen/screens/Home.dart';
import 'package:psychiatrist_project/Patient/auth/signUpScreen.dart';
import 'package:psychiatrist_project/Patient/patientScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/widgets/app_assets.dart';
import 'package:psychiatrist_project/widgets/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psychiatrist_project/widgets/primary_button.dart';
import 'package:psychiatrist_project/widgets/social_buttom.dart';
import 'package:psychiatrist_project/widgets/text_button.dart';
import 'package:psychiatrist_project/widgets/text_filed.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isRemember = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _signInController = Get.put(AuthController());

  var role = Get.arguments['role'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kLightWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 66),
              Center(
                  child: Text('Sign In $role',
                      style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              const SizedBox(height: 5),
              const Text('Welcome back! Please enter your details',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: Colors.black)),
              const SizedBox(height: 68),
              AuthField(
                  iconColor: AppColors.kLavender,
                  onChanged: (value) =>
                      _signInController.email.value = value,
                  keyboardType: TextInputType.emailAddress,
                  icon: "assets/icons/user.svg",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!value.isEmail) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                  hintText: 'Email address'),
              const SizedBox(height: 16),
              AuthField(
                  iconColor: AppColors.kPeriwinkle,
                  onChanged: (value) =>
                      _signInController.password.value = value,
                  keyboardType: TextInputType.visiblePassword,
                  icon: 'assets/icons/lock.svg',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!_isPasswordStrong(value)) {
                      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit.';
                    }
                    return null;
                  },
                  hintText: 'Password'),
              const SizedBox(height: 14),
              RememberMeCheckbox(
                onRememberChanged: (value) {
                  setState(() {
                    isRemember = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              CustomTextButton(onPressed: () {}, text: 'Forgot Password'),
              PrimaryButton(
                  onTapBtn: () {
                    _signInController.signIn();
                  },
                  text: 'SIgn In'),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Text('Create account',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  PrimaryButton(
                    onTapBtn: () {
                      Get.to(SignUpPage(), arguments: {"role": "$role"});
                    },
                    text: 'Sign UP',
                    height: 30,
                    width: 70,
                    fontColor: AppColors.kPrimary,
                    btnColor: AppColors.kLightWhite2,
                    fontSize: 12,
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(onTap: () {}, icon: 'assets/icons/google.svg'),
                  const SizedBox(width: 31),
                  SocialButton(onTap: () {}, icon: 'assets/icons/facebook.svg'),
                  const SizedBox(width: 31),
                  SocialButton(onTap: () {}, icon: 'assets/icons/apple.svg'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isPasswordStrong(String password) {
    if (password.length < 8) {
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    return true;
  }
}

class RememberMeCheckbox extends StatefulWidget {
  final void Function(bool) onRememberChanged;
  const RememberMeCheckbox({super.key, required this.onRememberChanged});

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  bool isRemember = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isRemember = !isRemember;
        });

        widget.onRememberChanged(isRemember);
      },
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
                color: isRemember ? AppColors.kPrimary : null,
                borderRadius: BorderRadius.circular(6),
                border: !isRemember
                    ? Border.all(color: const Color(0xFFB6B6B8))
                    : null),
            child: isRemember
                ? Icon(Icons.done, size: 14, color: AppColors.kLightWhite)
                : null,
          ),
          const SizedBox(width: 10),
          const Text(
            'Remember',
            style: TextStyle(fontSize: 12, color: Colors.black),
          )
        ],
      ),
    );
  }
}

class ImagesPath {
  static String kGoogleIcon = 'assets/images/googleSymbol.png';
}
