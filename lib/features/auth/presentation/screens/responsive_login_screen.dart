import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'login_screen.dart';
import 'mobile_login_screen.dart';

class ResponsiveLoginScreen extends StatelessWidget {
  const ResponsiveLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => const MobileLoginScreen(),
      tablet: (context) => const LoginScreen(),
      desktop: (context) => const LoginScreen(),
    );
  }
}
