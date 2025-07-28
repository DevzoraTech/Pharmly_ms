import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/order_provider.dart';
import '../../../../core/providers/product_provider.dart';
import '../../../../core/providers/customer_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/constants/app_constants.dart';
import '../widgets/sidebar.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/summary_card.dart';
import '../widgets/sales_analytics_chart.dart';
import '../widgets/top_selling_medicine_chart.dart';
import '../widgets/latest_orders_table.dart';
import '../../../products/presentation/screens/products_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onSidebarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load data when the dashboard is first created
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

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => const _DashboardMobile(),
      tablet:
          (context) => _DashboardWeb(
            selectedIndex: _selectedIndex,
            onSidebarItemSelected: _onSidebarItemSelected,
          ),
      desktop:
          (context) => _DashboardWeb(
            selectedIndex: _selectedIndex,
            onSidebarItemSelected: _onSidebarItemSelected,
          ),
    );
  }
}

class _DashboardWeb extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSidebarItemSelected;

  const _DashboardWeb({
    super.key,
    required this.selectedIndex,
    required this.onSidebarItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);

    Widget mainContent;
    switch (selectedIndex) {
      case 0:
        mainContent = _buildDashboardContent(
          context,
          orderProvider,
          productProvider,
          customerProvider,
        );
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
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: onSidebarItemSelected,
          ),
          Expanded(child: mainContent),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    OrderProvider orderProvider,
    ProductProvider productProvider,
    CustomerProvider customerProvider,
  ) {
    final isLoading =
        orderProvider.status == OrderLoadingStatus.loading ||
        productProvider.status == ProductLoadingStatus.loading ||
        customerProvider.status == CustomerLoadingStatus.loading;

    final hasError =
        orderProvider.status == OrderLoadingStatus.error ||
        productProvider.status == ProductLoadingStatus.error ||
        customerProvider.status == CustomerLoadingStatus.error;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                orderProvider.loadOrders();
                productProvider.loadProducts();
                customerProvider.loadCustomers();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardTopBar(),
            const SizedBox(height: 24),
            // Cards row
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop: Row as before
                  return Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.attach_money,
                          title: 'Total Profit',
                          value:
                              '\$${orderProvider.totalSales.toStringAsFixed(2)}',
                          subtitle: 'Since last week',
                          color: const Color(0xFF0B3C32),
                          statChange: '+2%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.person,
                          title: 'Total Customers',
                          value: customerProvider.totalCustomers.toString(),
                          subtitle: 'Since last week',
                          color: const Color(0xFFB6F09C),
                          statChange: '-0.2%',
                          statChangeColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.shopping_cart,
                          title: 'Total Orders',
                          value: orderProvider.orders.length.toString(),
                          subtitle: 'Since last week',
                          color: const Color(0xFF163D35),
                          statChange: '+6%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.bar_chart,
                          title: 'Sales',
                          value:
                              '\$${orderProvider.totalSales.toStringAsFixed(2)}',
                          subtitle: 'This month',
                          color: const Color(0xFFFFF6B2),
                          statChange: '+8%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                    ],
                  );
                } else {
                  // All non-desktop: single horizontal scrollable row
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CompactSummaryCard(
                          icon: Icons.attach_money,
                          title: 'Total Profit',
                          value:
                              '\$${orderProvider.totalSales.toStringAsFixed(2)}',
                          subtitle: 'Since last week',
                          color: const Color(0xFF0B3C32),
                          statChange: '+2%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        _CompactSummaryCard(
                          icon: Icons.person,
                          title: 'Total Customers',
                          value: customerProvider.totalCustomers.toString(),
                          subtitle: 'Since last week',
                          color: const Color(0xFFB6F09C),
                          statChange: '-0.2%',
                          statChangeColor: Colors.red,
                        ),
                        const SizedBox(width: 12),
                        _CompactSummaryCard(
                          icon: Icons.shopping_cart,
                          title: 'Total Orders',
                          value: orderProvider.orders.length.toString(),
                          subtitle: 'Since last week',
                          color: const Color(0xFF163D35),
                          statChange: '+6%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        _CompactSummaryCard(
                          icon: Icons.bar_chart,
                          title: 'Sales',
                          value:
                              '\$${orderProvider.totalSales.toStringAsFixed(2)}',
                          subtitle: 'This month',
                          color: const Color(0xFFFFF6B2),
                          statChange: '+8%',
                          statChangeColor: Colors.green,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            // Analytics and right panel
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop: Row as before
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sales Analytics
                      Expanded(
                        flex: 2,
                        child: SalesAnalyticsChart(
                          salesData:
                              orderProvider.monthlySales
                                  .map((data) => (data['sales'] as double))
                                  .toList(),
                          highlightedIndex: 6,
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right panel (Top Selling Medicine)
                      Expanded(
                        flex: 1,
                        child: TopSellingMedicineChart(
                          medicines: [
                            TopMedicine(
                              name: 'Keytruda',
                              sales: 80000,
                              color: const Color(0xFFFF7A00),
                              emoji: '💊',
                            ),
                            TopMedicine(
                              name: 'Ozempic',
                              sales: 60000,
                              color: const Color(0xFF222B45),
                              emoji: '💉',
                            ),
                            TopMedicine(
                              name: 'Dupixent',
                              sales: 30000,
                              color: const Color(0xFFB6F09C),
                              emoji: '💊',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Tablet/mobile: horizontal scroll
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 480,
                          child: SalesAnalyticsChart(
                            salesData:
                                orderProvider.monthlySales
                                    .map((data) => (data['sales'] as double))
                                    .toList(),
                            highlightedIndex: 6,
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 320,
                          child: TopSellingMedicineChart(
                            medicines: [
                              TopMedicine(
                                name: 'Keytruda',
                                sales: 80000,
                                color: const Color(0xFFFF7A00),
                                emoji: '💊',
                              ),
                              TopMedicine(
                                name: 'Ozempic',
                                sales: 60000,
                                color: const Color(0xFF222B45),
                                emoji: '💉',
                              ),
                              TopMedicine(
                                name: 'Dupixent',
                                sales: 30000,
                                color: const Color(0xFFB6F09C),
                                emoji: '💊',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            // Recent Orders Table
            LatestOrdersTable(orders: orderProvider.recentOrders),
          ],
        ),
      ),
    );
  }
}

class _DashboardMobile extends StatelessWidget {
  const _DashboardMobile();

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);

    final isLoading =
        orderProvider.status == OrderLoadingStatus.loading ||
        productProvider.status == ProductLoadingStatus.loading ||
        customerProvider.status == CustomerLoadingStatus.loading;

    final hasError =
        orderProvider.status == OrderLoadingStatus.error ||
        productProvider.status == ProductLoadingStatus.error ||
        customerProvider.status == CustomerLoadingStatus.error;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(
                'Error loading data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  orderProvider.loadOrders();
                  productProvider.loadProducts();
                  customerProvider.loadCustomers();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmly Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: Sidebar(
          selectedIndex: 0,
          onItemSelected: (index) {
            Navigator.pop(context);
            // Handle navigation
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CompactSummaryCard(
                      icon: Icons.attach_money,
                      title: 'Total Profit',
                      value: '\$${orderProvider.totalSales.toStringAsFixed(2)}',
                      subtitle: 'Since last week',
                      color: const Color(0xFF0B3C32),
                      statChange: '+2%',
                      statChangeColor: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    _CompactSummaryCard(
                      icon: Icons.person,
                      title: 'Total Customers',
                      value: customerProvider.totalCustomers.toString(),
                      subtitle: 'Since last week',
                      color: const Color(0xFFB6F09C),
                      statChange: '-0.2%',
                      statChangeColor: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    _CompactSummaryCard(
                      icon: Icons.shopping_cart,
                      title: 'Total Orders',
                      value: orderProvider.orders.length.toString(),
                      subtitle: 'Since last week',
                      color: const Color(0xFF163D35),
                      statChange: '+6%',
                      statChangeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sales Analytics Chart
              SalesAnalyticsChart(
                salesData:
                    orderProvider.monthlySales
                        .map((data) => (data['sales'] as double))
                        .toList(),
                highlightedIndex: 6,
              ),
              const SizedBox(height: 24),
              // Top Selling Medicine Chart
              TopSellingMedicineChart(
                medicines: [
                  TopMedicine(
                    name: 'Keytruda',
                    sales: 80000,
                    color: const Color(0xFFFF7A00),
                    emoji: '💊',
                  ),
                  TopMedicine(
                    name: 'Ozempic',
                    sales: 60000,
                    color: const Color(0xFF222B45),
                    emoji: '💉',
                  ),
                  TopMedicine(
                    name: 'Dupixent',
                    sales: 30000,
                    color: const Color(0xFFB6F09C),
                    emoji: '💊',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Recent Orders
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'View All',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...orderProvider.recentOrders
                          .take(5)
                          .map(
                            (order) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  order.id,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(order.customerName),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${order.totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _OrderStatusBadge(
                                      status: order.statusText,
                                      small: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class _CompactSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String? statChange;
  final Color? statChangeColor;

  const _CompactSummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.statChange,
    this.statChangeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (statChange != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statChangeColor!.withValues(alpha: 20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statChange!,
                    style: TextStyle(
                      color: statChangeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderStatusBadge extends StatelessWidget {
  final String status;
  final bool small;

  const _OrderStatusBadge({
    super.key,
    required this.status,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        color = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 20);
        break;
      case 'pending':
      case 'in progress':
        color = Colors.orange;
        backgroundColor = Colors.orange.withValues(alpha: 20);
        break;
      case 'cancelled':
      case 'failed':
        color = Colors.red;
        backgroundColor = Colors.red.withValues(alpha: 20);
        break;
      default:
        color = Colors.blue;
        backgroundColor = Colors.blue.withValues(alpha: 20);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
