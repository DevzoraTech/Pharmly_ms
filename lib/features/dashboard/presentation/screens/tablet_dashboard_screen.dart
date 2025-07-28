import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/order_provider.dart';
import '../../../../core/providers/product_provider.dart';
import '../../../../core/providers/customer_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/tablet_sidebar.dart';
import '../widgets/mobile_summary_cards.dart';
import '../widgets/mobile_sales_chart.dart';
import '../widgets/mobile_top_products.dart';
import '../widgets/mobile_recent_orders.dart';
import '../../../products/presentation/screens/products_screen.dart';

class TabletDashboardScreen extends StatefulWidget {
  const TabletDashboardScreen({super.key});

  @override
  State<TabletDashboardScreen> createState() => _TabletDashboardScreenState();
}

class _TabletDashboardScreenState extends State<TabletDashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    await Future.wait([
      productProvider.loadProducts(),
      orderProvider.loadOrders(),
      customerProvider.loadCustomers(),
    ]);
  }

  void _onSidebarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget mainContent;
    switch (_selectedIndex) {
      case 0:
        mainContent = _buildDashboardContent();
        break;
      case 1:
        mainContent = const ProductsScreen();
        break;
      default:
        mainContent = Center(
          child: Text(
            'Coming Soon!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Sidebar
          TabletSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onSidebarItemSelected,
            isExpanded: _isSidebarExpanded,
            onToggle: _toggleSidebar,
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(authProvider, themeProvider),

                // Content
                Expanded(child: mainContent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AuthProvider authProvider, ThemeProvider themeProvider) {
    final user = authProvider.user;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu button
          IconButton(
            onPressed: _toggleSidebar,
            icon: const Icon(Icons.menu_rounded),
            tooltip: 'Toggle Sidebar',
          ),
          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getPageTitle(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Welcome back, ${user?.name ?? 'User'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Theme toggle
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: 'Toggle Theme',
          ),

          // Notifications
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded),
            tooltip: 'Notifications',
          ),

          // Profile
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.accentColor,
            radius: 20,
            child: Text(
              user?.initials ?? 'U',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            const MobileSummaryCards(),
            const SizedBox(height: 32),

            // Charts row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sales chart
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    child: const MobileSalesChart(),
                  ),
                ),
                const SizedBox(width: 24),

                // Top products
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 400,
                    child: const MobileTopProducts(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent orders
            Container(height: 500, child: const MobileRecentOrders()),
          ],
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Products';
      case 2:
        return 'Orders';
      case 3:
        return 'Customers';
      case 4:
        return 'Payments';
      default:
        return 'Pharmly';
    }
  }
}
