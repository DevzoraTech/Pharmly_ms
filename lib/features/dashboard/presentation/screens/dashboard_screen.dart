import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/pharmly_app.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/constants/app_constants.dart';
import '../widgets/sidebar.dart';
import '../widgets/dashboard_top_bar.dart';
import '../widgets/summary_card.dart';
import '../widgets/sales_analytics_chart.dart';
import '../widgets/top_selling_medicine_chart.dart';
import '../widgets/latest_orders_table.dart';
import '../../../products/presentation/screens/products_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => _DashboardMobile(),
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
    Key? key,
    required this.selectedIndex,
    required this.onSidebarItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    switch (selectedIndex) {
      case 0:
        mainContent = SingleChildScrollView(
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
                              value: '\u000024,500',
                              subtitle: 'Since last week',
                              color: Color(0xFF0B3C32),
                              statChange: '+2%',
                              statChangeColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.person,
                              title: 'Total Customers',
                              value: '1,200',
                              subtitle: 'Since last week',
                              color: Color(0xFFB6F09C),
                              statChange: '-0.2%',
                              statChangeColor: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.shopping_cart,
                              title: 'Total Orders',
                              value: '2,549',
                              subtitle: 'Since last week',
                              color: Color(0xFF163D35),
                              statChange: '+6%',
                              statChangeColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.bar_chart,
                              title: 'Sales',
                              value: '\u000021,000',
                              subtitle: 'This month',
                              color: Color(0xFFFFF6B2),
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
                              value: '\u000024,500',
                              subtitle: 'Since last week',
                              color: Color(0xFF0B3C32),
                              statChange: '+2%',
                              statChangeColor: Colors.green,
                            ),
                            const SizedBox(width: 12),
                            _CompactSummaryCard(
                              icon: Icons.person,
                              title: 'Total Customers',
                              value: '1,200',
                              subtitle: 'Since last week',
                              color: Color(0xFFB6F09C),
                              statChange: '-0.2%',
                              statChangeColor: Colors.red,
                            ),
                            const SizedBox(width: 12),
                            _CompactSummaryCard(
                              icon: Icons.shopping_cart,
                              title: 'Total Orders',
                              value: '2,549',
                              subtitle: 'Since last week',
                              color: Color(0xFF163D35),
                              statChange: '+6%',
                              statChangeColor: Colors.green,
                            ),
                            const SizedBox(width: 12),
                            _CompactSummaryCard(
                              icon: Icons.bar_chart,
                              title: 'Sales',
                              value: '\u000021,000',
                              subtitle: 'This month',
                              color: Color(0xFFFFF6B2),
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
                              salesData: [
                                10000,
                                12000,
                                9000,
                                11000,
                                10500,
                                9500,
                                18657,
                                12000,
                                13000,
                                11000,
                                9000,
                                8000,
                              ],
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
                                  color: Color(0xFFFF7A00),
                                  emoji: '💊',
                                ),
                                TopMedicine(
                                  name: 'Ozempic',
                                  sales: 60000,
                                  color: Color(0xFF222B45),
                                  emoji: '💉',
                                ),
                                TopMedicine(
                                  name: 'Dupixent',
                                  sales: 30000,
                                  color: Color(0xFFB6F09C),
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
                            Container(
                              width: 480,
                              child: SalesAnalyticsChart(
                                salesData: [
                                  10000,
                                  12000,
                                  9000,
                                  11000,
                                  10500,
                                  9500,
                                  18657,
                                  12000,
                                  13000,
                                  11000,
                                  9000,
                                  8000,
                                ],
                                highlightedIndex: 6,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Container(
                              width: 320,
                              child: TopSellingMedicineChart(
                                medicines: [
                                  TopMedicine(
                                    name: 'Keytruda',
                                    sales: 80000,
                                    color: Color(0xFFFF7A00),
                                    emoji: '💊',
                                  ),
                                  TopMedicine(
                                    name: 'Ozempic',
                                    sales: 60000,
                                    color: Color(0xFF222B45),
                                    emoji: '💉',
                                  ),
                                  TopMedicine(
                                    name: 'Dupixent',
                                    sales: 30000,
                                    color: Color(0xFFB6F09C),
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
                // Recent Orders and Top Products Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth <= 900;
                    final orders = [
                      {
                        'id': '#ORD576',
                        'medicine': 'Paracetamol (2), Ibuprofen (1)',
                        'price': ' 25.50',
                        'orderStatus': 'Paid',
                        'paymentStatus': 'Completed',
                      },
                      {
                        'id': '#ORD575',
                        'medicine': 'Amoxicillin (3), Cetirizine (2)',
                        'price': ' 42.00',
                        'orderStatus': 'Pending',
                        'paymentStatus': 'In progress',
                      },
                      {
                        'id': '#ORD574',
                        'medicine': 'Loratadine (1), Omeprazole (1)',
                        'price': ' 15.00',
                        'orderStatus': 'Paid',
                        'paymentStatus': 'Pending',
                      },
                      {
                        'id': '#ORD573',
                        'medicine': 'Aspirin (4), Hydrocodone (1)',
                        'price': ' 48.00',
                        'orderStatus': 'Paid',
                        'paymentStatus': 'Completed',
                      },
                    ];
                    final topProducts = [
                      {
                        'img': null,
                        'name': 'Keytruda (Pembrolizumab)',
                        'subtitle': ' 356',
                        'sales': 359,
                      },
                      {
                        'img': null,
                        'name': 'Ozempic (semaglutide)',
                        'subtitle': ' 156',
                        'sales': 300,
                      },
                      {
                        'img': null,
                        'name': 'Dupixent (dupilumab)',
                        'subtitle': ' 254',
                        'sales': 289,
                      },
                      {
                        'img': null,
                        'name': 'Eliquis (apixaban)',
                        'subtitle': ' 59',
                        'sales': 248,
                      },
                      {
                        'img': null,
                        'name': 'Darzalex (daratumumab)',
                        'subtitle': ' 189',
                        'sales': 220,
                      },
                    ];
                    if (!isMobile) {
                      // Desktop/tablet: Row
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent Orders (2/3 width)
                          Expanded(
                            flex: 2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(right: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Recent Order',
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Color(0xFF163D35),
                                            textStyle: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    DataTable(
                                      columnSpacing: 18,
                                      headingRowHeight: 36,
                                      dataRowHeight: 44,
                                      border: TableBorder(
                                        horizontalInside: BorderSide(
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Order ID',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Medicine Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Price',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Order Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Payment Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Action',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:
                                          orders
                                              .map(
                                                (order) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(order['id']!),
                                                    ),
                                                    DataCell(
                                                      Text(order['medicine']!),
                                                    ),
                                                    DataCell(
                                                      Text(order['price']!),
                                                    ),
                                                    DataCell(
                                                      _OrderStatusBadge(
                                                        status:
                                                            order['orderStatus']!,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      _OrderStatusBadge(
                                                        status:
                                                            order['paymentStatus']!,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.more_horiz,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Top Products (1/3 width)
                          Expanded(
                            flex: 1,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(left: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Top Products',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        DropdownButton<String>(
                                          value: 'This Month',
                                          underline: SizedBox.shrink(),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'This Month',
                                              child: Text('This Month'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Last Month',
                                              child: Text('Last Month'),
                                            ),
                                          ],
                                          onChanged: (_) {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ...topProducts
                                        .map(
                                          (product) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.medication,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product['name']!
                                                            as String,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${product['sales']} sold',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  product['subtitle']!
                                                      as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Mobile/tablet: stack vertically
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Recent Order',
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Color(0xFF163D35),
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orders.length,
                                    separatorBuilder:
                                        (context, i) =>
                                            const SizedBox(height: 8),
                                    itemBuilder: (context, i) {
                                      final order = orders[i];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  order['id']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.more_horiz,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              order['medicine']!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                _OrderStatusBadge(
                                                  status: order['orderStatus']!,
                                                ),
                                                const SizedBox(width: 6),
                                                _OrderStatusBadge(
                                                  status:
                                                      order['paymentStatus']!,
                                                ),
                                                const Spacer(),
                                                Text(
                                                  order['price']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Top Products',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Spacer(),
                                      DropdownButton<String>(
                                        value: 'This Month',
                                        underline: SizedBox.shrink(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'This Month',
                                            child: Text('This Month'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Last Month',
                                            child: Text('Last Month'),
                                          ),
                                        ],
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...topProducts
                                      .map(
                                        (product) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.medication,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product['name']!
                                                          as String,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${product['sales']} sold',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                product['subtitle']! as String,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 18), // reduced from 24
                // Recent Orders Placeholder
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Recent Orders (Next Step)',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 1:
        mainContent = ProductsScreen();
        break;
      case 2:
        mainContent = OrdersScreen();
        break;
      case 3:
        mainContent = SalesScreen();
        break;
      case 4:
        mainContent = const Center(
          child: Text(
            'Customers Screen (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      case 5:
        mainContent = const Center(
          child: Text(
            'Payments Screen (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      case 6:
        mainContent = const Center(
          child: Text(
            'Help & Support (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      case 7:
        mainContent = const Center(
          child: Text(
            'Settings Screen (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      default:
        mainContent = const Center(
          child: Text('Unknown Tab', style: TextStyle(fontSize: 22)),
        );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: onSidebarItemSelected,
          ),
          // Main content
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}

class _DashboardMobile extends StatefulWidget {
  @override
  State<_DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<_DashboardMobile> {
  int _selectedIndex = 0;

  static const List<String> _tabTitles = [
    'Overview',
    'Products',
    'Orders',
    'Sales',
    'Customers',
    'Payments',
    'Help & Support',
    'Settings',
  ];

  void _onSidebarItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    switch (_selectedIndex) {
      case 0:
        mainContent = SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardTopBar(),
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
                              value: ' 24,500',
                              subtitle: 'Since last week',
                              color: Color(0xFF0B3C32),
                              statChange: '+2%',
                              statChangeColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.person,
                              title: 'Total Customers',
                              value: '1,200',
                              subtitle: 'Since last week',
                              color: Color(0xFFB6F09C),
                              statChange: '-0.2%',
                              statChangeColor: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.shopping_cart,
                              title: 'Total Orders',
                              value: '2,549',
                              subtitle: 'Since last week',
                              color: Color(0xFF163D35),
                              statChange: '+6%',
                              statChangeColor: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.bar_chart,
                              title: 'Sales',
                              value: ' 21,000',
                              subtitle: 'This month',
                              color: Color(0xFFFFF6B2),
                              statChange: '+8%',
                              statChangeColor: Colors.green,
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Tablet/mobile: horizontal scroll
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              width: 260,
                              child: SummaryCard(
                                icon: Icons.attach_money,
                                title: 'Total Profit',
                                value: ' 24,500',
                                subtitle: 'Since last week',
                                color: Color(0xFF0B3C32),
                                statChange: '+2%',
                                statChangeColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 260,
                              child: SummaryCard(
                                icon: Icons.person,
                                title: 'Total Customers',
                                value: '1,200',
                                subtitle: 'Since last week',
                                color: Color(0xFFB6F09C),
                                statChange: '-0.2%',
                                statChangeColor: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 260,
                              child: SummaryCard(
                                icon: Icons.shopping_cart,
                                title: 'Total Orders',
                                value: '2,549',
                                subtitle: 'Since last week',
                                color: Color(0xFF163D35),
                                statChange: '+6%',
                                statChangeColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 260,
                              child: SummaryCard(
                                icon: Icons.bar_chart,
                                title: 'Sales',
                                value: ' 21,000',
                                subtitle: 'This month',
                                color: Color(0xFFFFF6B2),
                                statChange: '+8%',
                                statChangeColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Sales Analytics
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      // Desktop: Row as before
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: SalesAnalyticsChart(
                              salesData: [
                                10000,
                                12000,
                                9000,
                                11000,
                                10500,
                                9500,
                                18657,
                                12000,
                                13000,
                                11000,
                                9000,
                                8000,
                              ],
                              highlightedIndex: 6,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Orders By Time',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        Flexible(
                                          child: Wrap(
                                            spacing: 6,
                                            runSpacing: 2,
                                            children: const [
                                              _HeatmapLegend(
                                                color: Color(0xFFB6F09C),
                                                label: '500',
                                              ),
                                              _HeatmapLegend(
                                                color: Color(0xFF0B3C32),
                                                label: '1,000',
                                              ),
                                              _HeatmapLegend(
                                                color: Color(0xFF163D35),
                                                label: '2,000',
                                              ),
                                              _HeatmapLegend(
                                                color: Color(0xFF222B45),
                                                label: '3,000+',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _OrdersByTimeHeatmap(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Tablet/mobile: stack vertically
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Orders By Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Spacer(),
                                      Flexible(
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 2,
                                          children: const [
                                            _HeatmapLegend(
                                              color: Color(0xFFB6F09C),
                                              label: '500',
                                            ),
                                            _HeatmapLegend(
                                              color: Color(0xFF0B3C32),
                                              label: '1,000',
                                            ),
                                            _HeatmapLegend(
                                              color: Color(0xFF163D35),
                                              label: '2,000',
                                            ),
                                            _HeatmapLegend(
                                              color: Color(0xFF222B45),
                                              label: '3,000+',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _OrdersByTimeHeatmap(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Top Selling Medicine
                TopSellingMedicineChart(
                  medicines: [
                    TopMedicine(
                      name: 'Keytruda',
                      sales: 80000,
                      color: Color(0xFFFF7A00),
                      emoji: '💊',
                    ),
                    TopMedicine(
                      name: 'Ozempic',
                      sales: 60000,
                      color: Color(0xFF222B45),
                      emoji: '💉',
                    ),
                    TopMedicine(
                      name: 'Dupixent',
                      sales: 30000,
                      color: Color(0xFFB6F09C),
                      emoji: '💊',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Recent Orders and Top Products Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth <= 900;
                    final orders = [
                      {
                        'id': '#ORD576',
                        'medicine': 'Paracetamol (2), Ibuprofen (1)',
                        'price': ' 25.50',
                        'orderStatus': 'Paid',
                        'paymentStatus': 'Completed',
                      },
                      {
                        'id': '#ORD575',
                        'medicine': 'Amoxicillin (3), Cetirizine (2)',
                        'price': ' 42.00',
                        'orderStatus': 'Pending',
                        'paymentStatus': 'In progress',
                      },
                      {
                        'id': '#ORD574',
                        'medicine': 'Loratadine (1), Omeprazole (1)',
                        'price': ' 15.00',
                        'orderStatus': 'Paid',
                        'paymentStatus': 'Pending',
                      },
                      {
                        'id': '#ORD573',
                        'medicine': 'Aspirin (4), Hydrocodone (1)',
                        'price': ' 48.00',
                        'orderStatus': 'Paid',
                        'paymentStatus': 'Completed',
                      },
                    ];
                    final topProducts = [
                      {
                        'img': null,
                        'name': 'Keytruda (Pembrolizumab)',
                        'subtitle': ' 356',
                        'sales': 359,
                      },
                      {
                        'img': null,
                        'name': 'Ozempic (semaglutide)',
                        'subtitle': ' 156',
                        'sales': 300,
                      },
                      {
                        'img': null,
                        'name': 'Dupixent (dupilumab)',
                        'subtitle': ' 254',
                        'sales': 289,
                      },
                      {
                        'img': null,
                        'name': 'Eliquis (apixaban)',
                        'subtitle': ' 59',
                        'sales': 248,
                      },
                      {
                        'img': null,
                        'name': 'Darzalex (daratumumab)',
                        'subtitle': ' 189',
                        'sales': 220,
                      },
                    ];
                    if (!isMobile) {
                      // Desktop/tablet: Row
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent Orders (2/3 width)
                          Expanded(
                            flex: 2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(right: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Recent Order',
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Color(0xFF163D35),
                                            textStyle: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    DataTable(
                                      columnSpacing: 18,
                                      headingRowHeight: 36,
                                      dataRowHeight: 44,
                                      border: TableBorder(
                                        horizontalInside: BorderSide(
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Order ID',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Medicine Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Price',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Order Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Payment Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Action',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows:
                                          orders
                                              .map(
                                                (order) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(order['id']!),
                                                    ),
                                                    DataCell(
                                                      Text(order['medicine']!),
                                                    ),
                                                    DataCell(
                                                      Text(order['price']!),
                                                    ),
                                                    DataCell(
                                                      _OrderStatusBadge(
                                                        status:
                                                            order['orderStatus']!,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      _OrderStatusBadge(
                                                        status:
                                                            order['paymentStatus']!,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.more_horiz,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Top Products (1/3 width)
                          Expanded(
                            flex: 1,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(left: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Top Products',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        DropdownButton<String>(
                                          value: 'This Month',
                                          underline: SizedBox.shrink(),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'This Month',
                                              child: Text('This Month'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Last Month',
                                              child: Text('Last Month'),
                                            ),
                                          ],
                                          onChanged: (_) {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ...topProducts
                                        .map(
                                          (product) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.medication,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product['name']!
                                                            as String,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${product['sales']} sold',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  product['subtitle']!
                                                      as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Mobile/tablet: stack vertically
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Recent Order',
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
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Color(0xFF163D35),
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orders.length,
                                    separatorBuilder:
                                        (context, i) =>
                                            const SizedBox(height: 8),
                                    itemBuilder: (context, i) {
                                      final order = orders[i];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  order['id']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.more_horiz,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              order['medicine']!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                _OrderStatusBadge(
                                                  status: order['orderStatus']!,
                                                ),
                                                const SizedBox(width: 6),
                                                _OrderStatusBadge(
                                                  status:
                                                      order['paymentStatus']!,
                                                ),
                                                const Spacer(),
                                                Text(
                                                  order['price']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Top Products',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const Spacer(),
                                      DropdownButton<String>(
                                        value: 'This Month',
                                        underline: SizedBox.shrink(),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'This Month',
                                            child: Text('This Month'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Last Month',
                                            child: Text('Last Month'),
                                          ),
                                        ],
                                        onChanged: (_) {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...topProducts
                                      .map(
                                        (product) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.medication,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product['name']!
                                                          as String,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${product['sales']} sold',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                product['subtitle']! as String,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 18), // reduced from 24
                // Recent Orders Placeholder
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Recent Orders (Next Step)',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 1:
        mainContent = ProductsScreen();
        break;
      case 2:
        mainContent = OrdersScreen();
        break;
      case 3:
        mainContent = SalesScreen();
        break;
      case 4:
        mainContent = const Center(
          child: Text(
            'Customers Screen (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      case 5:
        mainContent = const Center(
          child: Text(
            'Payments Screen (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      case 6:
        mainContent = const Center(
          child: Text(
            'Help & Support (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      case 7:
        mainContent = const Center(
          child: Text(
            'Settings Screen (Coming Soon)',
            style: TextStyle(fontSize: 22),
          ),
        );
        break;
      default:
        mainContent = const Center(
          child: Text('Unknown Tab', style: TextStyle(fontSize: 22)),
        );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(_tabTitles[_selectedIndex])),
      drawer: Drawer(
        child: Sidebar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onSidebarItemSelected,
        ),
      ),
      body: mainContent,
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SizedBox(height: 8),
            const Text(
              'Order List',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Let's check your pharmacy today",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Summary Cards Row
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop: Row
                  return Row(
                    children: [
                      Expanded(
                        child: _OrderSummaryCard(
                          title: 'Total Orders',
                          value: '1,256',
                          subtitle: 'Since last week',
                          extra: 'Revenue Generated: \$15,500',
                          statChange: '+2.7%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _OrderSummaryCard(
                          title: 'Completed Orders',
                          value: '875',
                          subtitle: 'Since last week',
                          extra: 'Revenue Generated: \$8,500',
                          statChange: '+2.7%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _OrderSummaryCard(
                          title: 'Pending Orders',
                          value: '235',
                          subtitle: 'Since last week',
                          extra: 'Approx Revenue: \$2,500',
                          statChange: '+3.7%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _OrderSummaryCard(
                          title: 'Cancelled Orders',
                          value: '5',
                          subtitle: 'Since last week',
                          extra: 'Lost Revenue: \$1,000',
                          statChange: '+0.2%',
                          statChangeColor: Colors.red,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile/tablet: horizontal scroll
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _OrderSummaryCard(
                          title: 'Total Orders',
                          value: '1,256',
                          subtitle: 'Since last week',
                          extra: 'Revenue Generated: \$15,500',
                          statChange: '+2.7%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        _OrderSummaryCard(
                          title: 'Completed Orders',
                          value: '875',
                          subtitle: 'Since last week',
                          extra: 'Revenue Generated: \$8,500',
                          statChange: '+2.7%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        _OrderSummaryCard(
                          title: 'Pending Orders',
                          value: '235',
                          subtitle: 'Since last week',
                          extra: 'Approx Revenue: \$2,500',
                          statChange: '+3.7%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        _OrderSummaryCard(
                          title: 'Cancelled Orders',
                          value: '5',
                          subtitle: 'Since last week',
                          extra: 'Lost Revenue: \$1,000',
                          statChange: '+0.2%',
                          statChangeColor: Colors.red,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            // Search and Controls Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth <= 600;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
                  child:
                      isMobile
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppTheme.grey,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.filter_list),
                                    onPressed: () {},
                                    tooltip: 'Filters',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download),
                                    onPressed: () {},
                                    tooltip: 'Export',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Color(0xFFB6F09C),
                                    ),
                                    onPressed: () {},
                                    tooltip: 'Add New Order',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'This Month',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          )
                          : Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppTheme.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFF163D35),
                                ),
                                label: const Text('Add New Order'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB6F09C),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.filter_list),
                                label: const Text('Filters'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download),
                                label: const Text('Export'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('This Month'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Order Table/List (responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth <= 600;
                final orders = [
                  {
                    'id': '#ORD001',
                    'customer': 'John Smith',
                    'date': '28-11-2024',
                    'products': 'Paracetamol (2), Ibuprofen (1)',
                    'amount': ' 25.50',
                    'payment': 'Paid',
                    'status': 'Completed',
                  },
                  {
                    'id': '#ORD002',
                    'customer': 'Emily Davis',
                    'date': '27-11-2024',
                    'products': 'Amoxicillin (3), Cetirizine (2)',
                    'amount': ' 42.00',
                    'payment': 'Pending',
                    'status': 'In progress',
                  },
                  {
                    'id': '#ORD003',
                    'customer': 'Michael Johnson',
                    'date': '26-11-2024',
                    'products': 'Loratadine (1), Omeprazole (1)',
                    'amount': ' 15.00',
                    'payment': 'Paid',
                    'status': 'Pending',
                  },
                  {
                    'id': '#ORD004',
                    'customer': 'Sarah Lee',
                    'date': '25-11-2024',
                    'products': 'Aspirin (4), Hydrocodone (1)',
                    'amount': ' 48.00',
                    'payment': 'Paid',
                    'status': 'Completed',
                  },
                  {
                    'id': '#ORD005',
                    'customer': 'David Brown',
                    'date': '25-11-2024',
                    'products': 'Albuterol Inhaler (1), Warfarin (2)',
                    'amount': ' 55.00',
                    'payment': 'Failed',
                    'status': 'Cancelled',
                  },
                ];
                if (!isMobile) {
                  // Web/tablet: DataTable
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Text('Showing ${orders.length} out of 100'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 24,
                              headingRowHeight: 40,
                              dataRowHeight: 48,
                              border: TableBorder(
                                horizontalInside: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Order ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Customer Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Order Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Products Ordered',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Payment Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Order Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Action',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows:
                                  orders
                                      .map(
                                        (order) => DataRow(
                                          cells: [
                                            DataCell(Text(order['id']!)),
                                            DataCell(Text(order['customer']!)),
                                            DataCell(Text(order['date']!)),
                                            DataCell(Text(order['products']!)),
                                            DataCell(Text(order['amount']!)),
                                            DataCell(
                                              _OrderStatusBadge(
                                                status: order['payment']!,
                                              ),
                                            ),
                                            DataCell(
                                              _OrderStatusBadge(
                                                status: order['status']!,
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.visibility,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (var i = 1; i <= 3; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor:
                                          i == 1 ? AppTheme.accentColor : null,
                                    ),
                                    child: Text(
                                      '$i',
                                      style: TextStyle(
                                        color:
                                            i == 1
                                                ? AppTheme.primaryColor
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              const Text('...'),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('10'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Mobile: Card ListView
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (context, i) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final order = orders[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0.5,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    order['id']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      order['customer']!,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Text(
                                    order['date']!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order['products']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _OrderStatusBadge(status: order['payment']!),
                                  const SizedBox(width: 6),
                                  _OrderStatusBadge(status: order['status']!),
                                  const Spacer(),
                                  Text(
                                    order['amount']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      size: 18,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String extra;
  final String statChange;
  final Color statChangeColor;
  const _OrderSummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.extra,
    required this.statChange,
    required this.statChangeColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statChangeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statChange,
                  style: TextStyle(
                    fontSize: 11,
                    color: statChangeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(extra, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

// Add a compact summary card widget for mobile/tablet
class _CompactSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String? statChange;
  final Color? statChangeColor;

  const _CompactSummaryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.statChange,
    this.statChangeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (statChange != null && statChangeColor != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: statChangeColor!.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statChange!,
                          style: TextStyle(
                            fontSize: 9,
                            color: statChangeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Order status badge widget
class _OrderStatusBadge extends StatelessWidget {
  final String status;
  const _OrderStatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Paid':
        color = Colors.green;
        break;
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Failed':
        color = Colors.red;
        break;
      case 'Completed':
        color = Colors.green;
        break;
      case 'In progress':
        color = Colors.orange;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class SalesScreen extends StatelessWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SizedBox(height: 8),
            const Text(
              'Sales Overview',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Let's check your pharmacy today",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Summary Cards Row
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop: Row
                  return Row(
                    children: [
                      Expanded(
                        child: _SalesSummaryCard(
                          title: 'Total Revenue',
                          value: ' 112,200',
                          subtitle: 'Since last week',
                          statChange: '+2%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12), // reduced from 16
                      Expanded(
                        child: _SalesSummaryCard(
                          title: 'Total Profit',
                          value: ' 12,500',
                          subtitle: 'Since last week',
                          statChange: '+8%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SalesSummaryCard(
                          title: 'Total Cost',
                          value: ' 48,200',
                          subtitle: 'Since last week',
                          statChange: '+0.2%',
                          statChangeColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SalesSummaryCard(
                          title: 'Average Order Value',
                          value: ' 96.50',
                          subtitle: 'Since last week',
                          statChange: '+5%',
                          statChangeColor: Colors.green,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile/tablet: horizontal scroll
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _SalesSummaryCard(
                          title: 'Total Revenue',
                          value: ' 112,200',
                          subtitle: 'Since last week',
                          statChange: '+2%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 10), // reduced from 12
                        _SalesSummaryCard(
                          title: 'Total Profit',
                          value: ' 12,500',
                          subtitle: 'Since last week',
                          statChange: '+8%',
                          statChangeColor: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        _SalesSummaryCard(
                          title: 'Total Cost',
                          value: ' 48,200',
                          subtitle: 'Since last week',
                          statChange: '+0.2%',
                          statChangeColor: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        _SalesSummaryCard(
                          title: 'Average Order Value',
                          value: ' 96.50',
                          subtitle: 'Since last week',
                          statChange: '+5%',
                          statChangeColor: Colors.green,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 18), // reduced from 24
            // Analytics Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth <= 900;
                if (!isMobile) {
                  // Web/tablet: side by side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Revenue Chart
                      Expanded(
                        flex: 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              16,
                            ), // reduced from 20
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Total Revenue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Spacer(),
                                    DropdownButton<String>(
                                      value: 'This Month',
                                      underline: SizedBox.shrink(),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'This Month',
                                          child: Text('This Month'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Last Month',
                                          child: Text('Last Month'),
                                        ),
                                      ],
                                      onChanged: (_) {},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12), // reduced from 16
                                SizedBox(
                                  height: 200, // reduced from 220
                                  child: BarChart(
                                    BarChartData(
                                      borderData: FlBorderData(show: false),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        getDrawingHorizontalLine:
                                            (value) => FlLine(
                                              color: Colors.grey.shade200,
                                              strokeWidth: 1,
                                            ),
                                      ),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 36,
                                            getTitlesWidget: (value, meta) {
                                              if (value % 5000 == 0) {
                                                return Text(
                                                  value == 0
                                                      ? '0'
                                                      : '${(value ~/ 1000).toString()}k',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            },
                                            interval: 5000,
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 32,
                                            getTitlesWidget: (value, meta) {
                                              final idx = value.toInt();
                                              if (idx < 0 || idx > 11)
                                                return const SizedBox.shrink();
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Text(
                                                  (idx + 1).toString().padLeft(
                                                    2,
                                                    '0',
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                            interval: 1,
                                          ),
                                        ),
                                      ),
                                      barGroups: List.generate(12, (i) {
                                        final data = [
                                          12000,
                                          9000,
                                          15000,
                                          8000,
                                          11000,
                                          9500,
                                          18657,
                                          12000,
                                          13000,
                                          11000,
                                          9000,
                                          8000,
                                        ];
                                        final isHighlighted = i == 6;
                                        return BarChartGroupData(
                                          x: i,
                                          barRods: [
                                            BarChartRodData(
                                              toY: data[i].toDouble(),
                                              color:
                                                  isHighlighted
                                                      ? const Color(0xFF163D35)
                                                      : const Color(0xFF0B3C32),
                                              width: 24,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              rodStackItems:
                                                  isHighlighted
                                                      ? [
                                                        BarChartRodStackItem(
                                                          0,
                                                          data[i].toDouble(),
                                                          const Color(
                                                            0xFFB6F09C,
                                                          ),
                                                        ),
                                                      ]
                                                      : [],
                                            ),
                                          ],
                                          showingTooltipIndicators:
                                              isHighlighted ? [0] : [],
                                        );
                                      }),
                                      barTouchData: BarTouchData(
                                        enabled: false,
                                      ),
                                      maxY: 25000,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18), // reduced from 24
                      // Orders By Time and Top Products stacked
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  14,
                                ), // reduced from 18
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Orders By Time',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        Flexible(
                                          child: Wrap(
                                            spacing: 6,
                                            runSpacing: 2,
                                            children: const [
                                              _HeatmapLegend(
                                                color: Color(0xFFB6F09C),
                                                label: '500',
                                              ),
                                              _HeatmapLegend(
                                                color: Color(0xFF0B3C32),
                                                label: '1,000',
                                              ),
                                              _HeatmapLegend(
                                                color: Color(0xFF163D35),
                                                label: '2,000',
                                              ),
                                              _HeatmapLegend(
                                                color: Color(0xFF222B45),
                                                label: '3,000+',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ), // reduced from 12
                                    _OrdersByTimeHeatmap(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14), // reduced from 18
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  14,
                                ), // reduced from 18
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Top Products',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        DropdownButton<String>(
                                          value: 'This Month',
                                          underline: SizedBox.shrink(),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'This Month',
                                              child: Text('This Month'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Last Month',
                                              child: Text('Last Month'),
                                            ),
                                          ],
                                          onChanged: (_) {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ), // reduced from 10
                                    ...[
                                          {
                                            'img': null,
                                            'name': 'Keytruda (Pembrolizumab)',
                                            'subtitle': ' 356',
                                            'sales': 359,
                                          },
                                          {
                                            'img': null,
                                            'name': 'Ozempic (semaglutide)',
                                            'subtitle': ' 156',
                                            'sales': 300,
                                          },
                                          {
                                            'img': null,
                                            'name': 'Dupixent (dupilumab)',
                                            'subtitle': ' 254',
                                            'sales': 289,
                                          },
                                          {
                                            'img': null,
                                            'name': 'Eliquis (apixaban)',
                                            'subtitle': ' 59',
                                            'sales': 248,
                                          },
                                          {
                                            'img': null,
                                            'name': 'Darzalex (daratumumab)',
                                            'subtitle': ' 189',
                                            'sales': 220,
                                          },
                                        ]
                                        .map(
                                          (product) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.medication,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product['name']!
                                                            as String,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${product['sales']} sold',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  product['subtitle']!
                                                      as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile/tablet: stack vertically, Total Revenue first
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16), // reduced from 20
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Total Revenue',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  DropdownButton<String>(
                                    value: 'This Month',
                                    underline: SizedBox.shrink(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'This Month',
                                        child: Text('This Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Last Month',
                                        child: Text('Last Month'),
                                      ),
                                    ],
                                    onChanged: (_) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12), // reduced from 16
                              SizedBox(
                                height: 200, // reduced from 220
                                child: BarChart(
                                  BarChartData(
                                    borderData: FlBorderData(show: false),
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine:
                                          (value) => FlLine(
                                            color: Colors.grey.shade200,
                                            strokeWidth: 1,
                                          ),
                                    ),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 36,
                                          getTitlesWidget: (value, meta) {
                                            if (value % 5000 == 0) {
                                              return Text(
                                                value == 0
                                                    ? '0'
                                                    : '${(value ~/ 1000).toString()}k',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                          interval: 5000,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 32,
                                          getTitlesWidget: (value, meta) {
                                            final idx = value.toInt();
                                            if (idx < 0 || idx > 11)
                                              return const SizedBox.shrink();
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: Text(
                                                (idx + 1).toString().padLeft(
                                                  2,
                                                  '0',
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            );
                                          },
                                          interval: 1,
                                        ),
                                      ),
                                    ),
                                    barGroups: List.generate(12, (i) {
                                      final data = [
                                        12000,
                                        9000,
                                        15000,
                                        8000,
                                        11000,
                                        9500,
                                        18657,
                                        12000,
                                        13000,
                                        11000,
                                        9000,
                                        8000,
                                      ];
                                      final isHighlighted = i == 6;
                                      return BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY: data[i].toDouble(),
                                            color:
                                                isHighlighted
                                                    ? const Color(0xFF163D35)
                                                    : const Color(0xFF0B3C32),
                                            width: 24,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            rodStackItems:
                                                isHighlighted
                                                    ? [
                                                      BarChartRodStackItem(
                                                        0,
                                                        data[i].toDouble(),
                                                        const Color(0xFFB6F09C),
                                                      ),
                                                    ]
                                                    : [],
                                          ),
                                        ],
                                        showingTooltipIndicators:
                                            isHighlighted ? [0] : [],
                                      );
                                    }),
                                    barTouchData: BarTouchData(enabled: false),
                                    maxY: 25000,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14), // reduced from 18
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(14), // reduced from 18
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Orders By Time',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Spacer(),
                                  Flexible(
                                    child: Wrap(
                                      spacing: 6,
                                      runSpacing: 2,
                                      children: const [
                                        _HeatmapLegend(
                                          color: Color(0xFFB6F09C),
                                          label: '500',
                                        ),
                                        _HeatmapLegend(
                                          color: Color(0xFF0B3C32),
                                          label: '1,000',
                                        ),
                                        _HeatmapLegend(
                                          color: Color(0xFF163D35),
                                          label: '2,000',
                                        ),
                                        _HeatmapLegend(
                                          color: Color(0xFF222B45),
                                          label: '3,000+',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10), // reduced from 12
                              _OrdersByTimeHeatmap(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14), // reduced from 18
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(14), // reduced from 18
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Top Products',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Spacer(),
                                  DropdownButton<String>(
                                    value: 'This Month',
                                    underline: SizedBox.shrink(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'This Month',
                                        child: Text('This Month'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Last Month',
                                        child: Text('Last Month'),
                                      ),
                                    ],
                                    onChanged: (_) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8), // reduced from 10
                              ...[
                                    {
                                      'img': null,
                                      'name': 'Keytruda (Pembrolizumab)',
                                      'subtitle': ' 356',
                                      'sales': 359,
                                    },
                                    {
                                      'img': null,
                                      'name': 'Ozempic (semaglutide)',
                                      'subtitle': ' 156',
                                      'sales': 300,
                                    },
                                    {
                                      'img': null,
                                      'name': 'Dupixent (dupilumab)',
                                      'subtitle': ' 254',
                                      'sales': 289,
                                    },
                                    {
                                      'img': null,
                                      'name': 'Eliquis (apixaban)',
                                      'subtitle': ' 59',
                                      'sales': 248,
                                    },
                                    {
                                      'img': null,
                                      'name': 'Darzalex (daratumumab)',
                                      'subtitle': ' 189',
                                      'sales': 220,
                                    },
                                  ]
                                  .map(
                                    (product) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.medication,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product['name']! as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  '${product['sales']} sold',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            product['subtitle']! as String,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 18), // reduced from 24
            // Recent Orders Widget
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth <= 600;
                final orders = [
                  {
                    'id': '#ORD576',
                    'medicine': 'Paracetamol (2), Ibuprofen (1)',
                    'price': ' 25.50',
                    'orderStatus': 'Paid',
                    'paymentStatus': 'Completed',
                  },
                  {
                    'id': '#ORD575',
                    'medicine': 'Amoxicillin (3), Cetirizine (2)',
                    'price': ' 42.00',
                    'orderStatus': 'Pending',
                    'paymentStatus': 'In progress',
                  },
                  {
                    'id': '#ORD574',
                    'medicine': 'Loratadine (1), Omeprazole (1)',
                    'price': ' 15.00',
                    'orderStatus': 'Paid',
                    'paymentStatus': 'Pending',
                  },
                  {
                    'id': '#ORD573',
                    'medicine': 'Aspirin (4), Hydrocodone (1)',
                    'price': ' 48.00',
                    'orderStatus': 'Paid',
                    'paymentStatus': 'Completed',
                  },
                ];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16), // reduced from 20
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Recent Order',
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
                              style: TextButton.styleFrom(
                                foregroundColor: Color(0xFF163D35),
                                textStyle: const TextStyle(fontSize: 13),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6), // reduced from 10
                        if (!isMobile)
                          // Desktop/tablet: DataTable
                          DataTable(
                            columnSpacing: 18,
                            headingRowHeight: 36,
                            dataRowHeight: 44,
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                            ),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Order ID',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Medicine Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Price',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Order Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Payment Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Action',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows:
                                orders
                                    .map(
                                      (order) => DataRow(
                                        cells: [
                                          DataCell(Text(order['id']!)),
                                          DataCell(Text(order['medicine']!)),
                                          DataCell(Text(order['price']!)),
                                          DataCell(
                                            _OrderStatusBadge(
                                              status: order['orderStatus']!,
                                            ),
                                          ),
                                          DataCell(
                                            _OrderStatusBadge(
                                              status: order['paymentStatus']!,
                                            ),
                                          ),
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                size: 20,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          )
                        else
                          // Mobile: Card List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            separatorBuilder:
                                (context, i) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final order = orders[i];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          order['id']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.more_horiz,
                                            size: 18,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      order['medicine']!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        _OrderStatusBadge(
                                          status: order['orderStatus']!,
                                        ),
                                        const SizedBox(width: 6),
                                        _OrderStatusBadge(
                                          status: order['paymentStatus']!,
                                        ),
                                        const Spacer(),
                                        Text(
                                          order['price']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18), // reduced from 24
            // Recent Orders Placeholder
            Container(
              height: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Recent Orders (Next Step)',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String statChange;
  final Color statChangeColor;
  const _SalesSummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.statChange,
    required this.statChangeColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statChangeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statChange,
                  style: TextStyle(
                    fontSize: 11,
                    color: statChangeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Add Orders By Time heatmap widget and legend
class _HeatmapLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _HeatmapLegend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _OrdersByTimeHeatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data: 7 days (Sun-Sat) x 6 hours (9am-7pm)
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final hours = ['9 am', '11 am', '1 pm', '3 pm', '5 pm', '7 pm'];
    final data = [
      [500, 1000, 2000, 3000, 500, 1000, 2000],
      [1000, 2000, 3000, 500, 1000, 2000, 3000],
      [2000, 3000, 500, 1000, 2000, 3000, 500],
      [3000, 500, 1000, 2000, 3000, 500, 1000],
      [500, 1000, 2000, 3000, 500, 1000, 2000],
      [1000, 2000, 3000, 500, 1000, 2000, 3000],
    ];
    Color getColor(int value) {
      if (value >= 3000) return const Color(0xFF222B45);
      if (value >= 2000) return const Color(0xFF163D35);
      if (value >= 1000) return const Color(0xFF0B3C32);
      return const Color(0xFFB6F09C);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 40),
            ...days.map(
              (d) => SizedBox(
                width: 28,
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...List.generate(
          hours.length,
          (i) => Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  hours[i],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              ...List.generate(
                days.length,
                (j) => Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: getColor(data[i][j]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
