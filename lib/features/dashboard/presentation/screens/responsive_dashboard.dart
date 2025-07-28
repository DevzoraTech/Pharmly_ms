import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dashboard_screen_fixed.dart';
import 'mobile_dashboard_screen.dart';
import 'tablet_dashboard_screen.dart';

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => const MobileDashboardScreen(),
      tablet: (context) => const TabletDashboardScreen(),
      desktop: (context) => const DashboardScreen(),
    );
  }
}
