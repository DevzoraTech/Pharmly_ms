import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../common/constants/app_constants.dart';
import '../../../dashboard/presentation/widgets/summary_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.accentColor,
                  radius: 32,
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'James Bond',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text(
                  '@james.bond',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 8 : AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Product List',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Let's check your pharmacy today",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Search bar
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
                        const SizedBox(width: 8),
                        // Notification icon
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        // User profile
                        if (!isMobile)
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.accentColor,
                                radius: 18,
                                child: Text(
                                  'J',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'James Bond',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '@james.bond',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppTheme.primaryColor,
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showProfileSheet(context),
                                child: CircleAvatar(
                                  backgroundColor: AppTheme.accentColor,
                                  radius: 18,
                                  child: Text(
                                    'J',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                color: AppTheme.primaryColor,
                                onPressed: () => _showProfileSheet(context),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Summary Cards: always a single horizontal scrollable row on mobile/tablet
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      // Desktop: Row as before
                      return Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.inventory_2,
                              title: 'Total Products',
                              value: '20,579',
                              subtitle: '',
                              color: Color(0xFF163D35),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.warning_amber_rounded,
                              title: 'Low Stock Items',
                              value: '120',
                              subtitle: '',
                              color: Color(0xFFFFF6B2),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              icon: Icons.cancel,
                              title: 'Out of Stock',
                              value: '89',
                              subtitle: '',
                              color: Color(0xFFFFE0E0),
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
                              icon: Icons.inventory_2,
                              title: 'Total Products',
                              value: '20,579',
                              subtitle: '',
                              color: Color(0xFF163D35),
                            ),
                            const SizedBox(width: 12),
                            _CompactSummaryCard(
                              icon: Icons.warning_amber_rounded,
                              title: 'Low Stock Items',
                              value: '120',
                              subtitle: '',
                              color: Color(0xFFFFF6B2),
                            ),
                            const SizedBox(width: 12),
                            _CompactSummaryCard(
                              icon: Icons.cancel,
                              title: 'Out of Stock',
                              value: '89',
                              subtitle: '',
                              color: Color(0xFFFFE0E0),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Category Cards: ListView for mobile, Grid for larger screens
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth <= 600;
                    if (isMobile) {
                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: const [
                          _ProductCategoryCard(
                            icon: Icons.healing,
                            title: 'Antibiotics',
                            value: '120',
                            statChange: '+2%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.spa,
                            title: 'Pain Relievers',
                            value: '95',
                            statChange: '+0.6%',
                            statChangeColor: Colors.red,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.local_hospital,
                            title: 'Vitamins & Supplements',
                            value: '75',
                            statChange: '+2%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.coronavirus,
                            title: 'Antiviral Drugs',
                            value: '50',
                            statChange: '+0.2%',
                            statChangeColor: Colors.red,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.bloodtype,
                            title: 'Diabetes Care',
                            value: '65',
                            statChange: '+0.1%',
                            statChangeColor: Colors.red,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.favorite,
                            title: 'Cardiovascular',
                            value: '80',
                            statChange: '+8%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.medication,
                            title: 'Allergy Medication',
                            value: '40',
                            statChange: '+5%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.air,
                            title: 'Respiratory Medicines',
                            value: '55',
                            statChange: '+2.6%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: true,
                          ),
                        ],
                      );
                    } else {
                      int crossAxisCount = constraints.maxWidth > 900 ? 4 : 2;
                      double aspectRatio = 2.2;
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: const [
                          _ProductCategoryCard(
                            icon: Icons.healing,
                            title: 'Antibiotics',
                            value: '120',
                            statChange: '+2%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.spa,
                            title: 'Pain Relievers',
                            value: '95',
                            statChange: '+0.6%',
                            statChangeColor: Colors.red,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.local_hospital,
                            title: 'Vitamins & Supplements',
                            value: '75',
                            statChange: '+2%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.coronavirus,
                            title: 'Antiviral Drugs',
                            value: '50',
                            statChange: '+0.2%',
                            statChangeColor: Colors.red,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.bloodtype,
                            title: 'Diabetes Care',
                            value: '65',
                            statChange: '+0.1%',
                            statChangeColor: Colors.red,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.favorite,
                            title: 'Cardiovascular',
                            value: '80',
                            statChange: '+8%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.medication,
                            title: 'Allergy Medication',
                            value: '40',
                            statChange: '+5%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                          _ProductCategoryCard(
                            icon: Icons.air,
                            title: 'Respiratory Medicines',
                            value: '55',
                            statChange: '+2.6%',
                            statChangeColor: Colors.green,
                            subtitle: 'Since last week',
                            isMobile: false,
                          ),
                        ],
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
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 8 : 12,
                      ),
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                        tooltip: 'Add New Product',
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
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Color(0xFF163D35),
                                    ),
                                    label: const Text('Add New Product'),
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
                // Product Table/List (responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth <= 600;
                    final products = [
                      {
                        'id': '#001',
                        'name': 'Paracetamol 500mg',
                        'quantity': '120 Units',
                        'price': ' 5.00',
                        'expiry': '15-03-2025',
                        'status': 'In stock',
                      },
                      {
                        'id': '#002',
                        'name': 'Amoxicillin 250mg',
                        'quantity': '45 Units',
                        'price': ' 7.50',
                        'expiry': '01-12-2024',
                        'status': 'Low stock',
                      },
                      {
                        'id': '#003',
                        'name': 'Ibuprofen 200mg',
                        'quantity': '0 Units',
                        'price': ' 6.00',
                        'expiry': '15-11-2023',
                        'status': 'Out of stock',
                      },
                      {
                        'id': '#004',
                        'name': 'Cetirizine 10mg',
                        'quantity': '150 Units',
                        'price': ' 3.50',
                        'expiry': '30-06-2026',
                        'status': 'In stock',
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
                                  Text('Showing 4 out of 100'),
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
                                        'Product ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Product Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Quantity',
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
                                        'Expiry Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Status',
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
                                      products
                                          .map(
                                            (product) => DataRow(
                                              cells: [
                                                DataCell(Text(product['id']!)),
                                                DataCell(
                                                  Text(product['name']!),
                                                ),
                                                DataCell(
                                                  Text(product['quantity']!),
                                                ),
                                                DataCell(
                                                  Text(product['price']!),
                                                ),
                                                DataCell(
                                                  Text(product['expiry']!),
                                                ),
                                                DataCell(
                                                  _ProductStatusBadge(
                                                    status: product['status']!,
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor:
                                              i == 1
                                                  ? AppTheme.accentColor
                                                  : null,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                      // Mobile: ListView
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
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      Expanded(
                                        child: Text(
                                          'Product ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Product Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  ...products.map(
                                    (product) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(product['id']!)),
                                          Expanded(
                                            child: Text(product['name']!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // ... (rest of the Products screen UI will go here)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Category Card Widget
class _ProductCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String statChange;
  final Color statChangeColor;
  final String subtitle;
  final bool isMobile;

  const _ProductCategoryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.statChange,
    required this.statChangeColor,
    required this.subtitle,
    this.isMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = isMobile ? 30 : 28;
    final double cardPadding = isMobile ? 8 : 16;
    final double titleFont = isMobile ? 14 : 14;
    final double valueFont = isMobile ? 18 : 20;
    final double statFont = isMobile ? 11 : 11;
    final double subtitleFont = isMobile ? 11 : 11;
    return ConstrainedBox(
      constraints:
          isMobile ? BoxConstraints(maxWidth: 180) : const BoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        margin: isMobile ? const EdgeInsets.symmetric(horizontal: 2) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: isMobile ? 10 : 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 10 : 10),
              decoration: BoxDecoration(
                color: statChangeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: statChangeColor, size: iconSize),
            ),
            SizedBox(width: isMobile ? 10 : 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: titleFont,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: isMobile ? 6 : 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 6 : 6,
                          vertical: isMobile ? 2 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: statChangeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statChange,
                          style: TextStyle(
                            fontSize: statFont,
                            color: statChangeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: valueFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMobile ? 0 : 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: subtitleFont,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Product status badge widget
class _ProductStatusBadge extends StatelessWidget {
  final String status;
  const _ProductStatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'In stock':
        color = Colors.green;
        break;
      case 'Low stock':
        color = Colors.orange;
        break;
      case 'Out of stock':
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

// Add a compact summary card widget for mobile/tablet
class _CompactSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _CompactSummaryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 100,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
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
