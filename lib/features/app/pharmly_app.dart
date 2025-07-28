import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../auth/presentation/screens/responsive_login_screen.dart';
import '../dashboard/presentation/screens/responsive_dashboard.dart';

class PharmlyApp extends StatelessWidget {
  const PharmlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Pharmly',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home:
          authProvider.isAuthenticated
              ? const ResponsiveDashboard()
              : const ResponsiveLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
