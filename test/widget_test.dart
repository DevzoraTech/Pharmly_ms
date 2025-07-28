// This is a basic Flutter widget test for Pharmly app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gn_leaf_ms/core/providers/auth_provider.dart';
import 'package:gn_leaf_ms/core/providers/customer_provider.dart';
import 'package:gn_leaf_ms/core/providers/order_provider.dart';
import 'package:gn_leaf_ms/core/providers/product_provider.dart';
import 'package:gn_leaf_ms/core/providers/theme_provider.dart';
import 'package:gn_leaf_ms/core/services/api_service.dart';
import 'package:gn_leaf_ms/core/services/auth_service.dart';
import 'package:gn_leaf_ms/core/services/customer_service.dart';
import 'package:gn_leaf_ms/core/services/order_service.dart';
import 'package:gn_leaf_ms/core/services/product_service.dart';
import 'package:gn_leaf_ms/features/app/pharmly_app.dart';

void main() {
  testWidgets('Pharmly app smoke test', (WidgetTester tester) async {
    // Create services
    final apiService = ApiService(baseUrl: 'https://api.pharmly.com');
    final authService = AuthService(apiService: apiService, useMockData: true);
    final productService = ProductService(
      apiService: apiService,
      useMockData: true,
    );
    final orderService = OrderService(
      apiService: apiService,
      useMockData: true,
    );
    final customerService = CustomerService(
      apiService: apiService,
      useMockData: true,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(authService: authService),
          ),
          ChangeNotifierProvider(
            create: (_) => ProductProvider(productService: productService),
          ),
          ChangeNotifierProvider(
            create: (_) => OrderProvider(orderService: orderService),
          ),
          ChangeNotifierProvider(
            create: (_) => CustomerProvider(customerService: customerService),
          ),
        ],
        child: const PharmlyApp(),
      ),
    );

    // Verify that the login screen is displayed initially
    expect(find.text('Login to your account'), findsOneWidget);
    expect(find.text('Pharmly'), findsOneWidget);
  });
}
