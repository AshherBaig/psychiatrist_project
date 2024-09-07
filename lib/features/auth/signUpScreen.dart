import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/auth/signInScreen.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/widgets/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psychiatrist_project/widgets/primary_button.dart';
import 'package:psychiatrist_project/widgets/social_buttom.dart';
import 'package:psychiatrist_project/widgets/text_button.dart';
import 'package:psychiatrist_project/widgets/text_filed.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isRemember = false;
  final AuthController _signUpController = Get.put(AuthController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signUpController.fullName.value = "";
    _signUpController.email.value = "";
    _signUpController.password.value = "";
    _signUpController.specialization.value = "";
    _signUpController.licenseNumber.value = "";
    _signUpController.address.value = "";
    _signUpController.uniName.value = "";
    _signUpController.yearsOfExperience.value = "";
    _signUpController.role.value = "";
  }

  @override
  Widget build(BuildContext context) {
    var role = Get.arguments['role'];
    _signUpController.role.value = role;
    _signUpController.SignUp();

    return Scaffold(
      backgroundColor: AppColors.kLightWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 66),
              Center(
                child: Text('Sign Up $role',
                    style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              const SizedBox(height: 5),
              const Text('Register yourself',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: Colors.black)),
              const SizedBox(height: 68),
              //    Full Name field

              AuthField(
                  iconColor: AppColors.kLavender,
                  onChanged: (value) => _signUpController.fullName.value = value,
                  keyboardType: TextInputType.name,
                  icon: "assets/icons/user.svg",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  hintText: 'Full Name'),
              const SizedBox(height: 16),
              // Email field
              AuthField(
                  iconColor: AppColors.kLavender,
                  onChanged: (value) => _signUpController.email.value = value,
                  keyboardType: TextInputType.emailAddress,
                  icon: "assets/icons/mail.svg",
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
              // Password field
              AuthField(
                  iconColor: AppColors.kPeriwinkle,
                  onChanged: (value) =>
                      _signUpController.password.value = value,
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
              const SizedBox(height: 16),
              // Conditionally show additional fields for doctors
              if (role == 'Doctor') ...[
                  AuthField(
                    iconColor: AppColors.kLavender,
                    onChanged: (value) =>
                        _signUpController.uniName.value = value,
                    keyboardType: TextInputType.text,
                    icon: "assets/icons/direction-right.svg",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your University Name';
                      }
                      return null;
                    },
                    hintText: 'University Name'),
                const SizedBox(height: 16),
                AuthField(
                    iconColor: AppColors.kLavender,
                    onChanged: (value) =>
                        _signUpController.yearsOfExperience.value = value,
                    keyboardType: TextInputType.text,
                    icon: "assets/icons/direction-right.svg",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your years Of Experience';
                      }
                      return null;
                    },
                    hintText: 'Years Of Experience'),
                const SizedBox(height: 16),
                AuthField(
                    iconColor: AppColors.kLavender,
                    onChanged: (value) =>
                        _signUpController.licenseNumber.value = value,
                    keyboardType: TextInputType.text,
                    icon: "assets/icons/certificate.svg",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your license number';
                      }
                      return null;
                    },
                    hintText: 'License Number'),
                const SizedBox(height: 16),
                AuthField(
                    iconColor: AppColors.kLavender,
                    onChanged: (value) =>
                        _signUpController.specialization.value = value,
                    keyboardType: TextInputType.text,
                    icon: "assets/icons/special.svg",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your specialization';
                      }
                      return null;
                    },
                    hintText: 'Specialization'),
                const SizedBox(height: 16),
                AuthField(
                    iconColor: AppColors.kLavender,
                    onChanged: (value) =>
                        _signUpController.address.value = value,
                    keyboardType: TextInputType.streetAddress,
                    icon: "assets/icons/address.svg",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your clinic address';
                      }
                      return null;
                    },
                    hintText: 'Clinic Address'),
              ],
              const SizedBox(height: 15),
              CustomTextButton(onPressed: () {}, text: 'Forgot Password'),
              PrimaryButton(
                  onTapBtn: _signUpController.SignUp, text: 'Sign Up'),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Text('Already have an account?',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  PrimaryButton(
                    onTapBtn: () {
                      Get.to(SignInPage(), arguments: {'role': role});
                    },
                    text: 'Sign In',
                    height: 30,
                    width: 70,
                    fontColor: AppColors.kPrimary,
                    btnColor: AppColors.kLightWhite2,
                    fontSize: 12,
                  )
                ],
              ),
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
