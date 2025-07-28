import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/customer_provider.dart';
import 'core/providers/order_provider.dart';
import 'core/providers/product_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/customer_service.dart';
import 'core/services/order_service.dart';
import 'core/services/product_service.dart';
import 'features/app/pharmly_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create services
  final apiService = ApiService(baseUrl: 'https://api.pharmly.com');
  final authService = AuthService(apiService: apiService, useMockData: true);
  final productService = ProductService(
    apiService: apiService,
    useMockData: true,
  );
  final orderService = OrderService(apiService: apiService, useMockData: true);
  final customerService = CustomerService(
    apiService: apiService,
    useMockData: true,
  );

  runApp(
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
}
