import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/order_provider.dart';
import '../../../../core/providers/product_provider.dart';
import '../../../../core/providers/customer_provider.dart';
import '../../../../core/theme/app_theme.dart';

class MobileSummaryCards extends StatelessWidget {
  const MobileSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<OrderProvider, ProductProvider, CustomerProvider>(
      builder: (
        context,
        orderProvider,
        productProvider,
        customerProvider,
        child,
      ) {
        final isLoading =
            orderProvider.status == OrderLoadingStatus.loading ||
            productProvider.status == ProductLoadingStatus.loading ||
            customerProvider.status == CustomerLoadingStatus.loading;

        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Primary metrics row
              Row(
                children: [
                  Expanded(
                    child: _MobileSummaryCard(
                      icon: Icons.trending_up_rounded,
                      title: 'Total Sales',
                      value: '\$${orderProvider.totalSales.toStringAsFixed(0)}',
                      change: '+12.5%',
                      changeColor: Colors.green,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B3C32), Color(0xFF1A5A4A)],
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MobileSummaryCard(
                      icon: Icons.people_rounded,
                      title: 'Customers',
                      value: customerProvider.totalCustomers.toString(),
                      change: '+8.2%',
                      changeColor: Colors.green,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB6F09C), Color(0xFFA8E890)],
                      ),
                      iconColor: AppTheme.primaryColor,
                      textColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Secondary metrics row
              Row(
                children: [
                  Expanded(
                    child: _MobileSummaryCard(
                      icon: Icons.shopping_bag_rounded,
                      title: 'Orders',
                      value: orderProvider.orders.length.toString(),
                      change: '+15.3%',
                      changeColor: Colors.green,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade700],
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MobileSummaryCard(
                      icon: Icons.inventory_rounded,
                      title: 'Products',
                      value: productProvider.products.length.toString(),
                      change: '+3.1%',
                      changeColor: Colors.orange,
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade500,
                          Colors.orange.shade600,
                        ],
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Alert cards
              _buildAlertCards(productProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertCards(ProductProvider productProvider) {
    final lowStockCount = productProvider.lowStockProducts.length;
    final outOfStockCount = productProvider.outOfStockProducts.length;
    final expiringSoonCount = productProvider.expiringSoonProducts.length;

    if (lowStockCount == 0 && outOfStockCount == 0 && expiringSoonCount == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (outOfStockCount > 0)
          _AlertCard(
            icon: Icons.error_rounded,
            title: 'Out of Stock',
            count: outOfStockCount,
            color: Colors.red,
            onTap: () {},
          ),
        if (lowStockCount > 0) ...[
          if (outOfStockCount > 0) const SizedBox(height: 8),
          _AlertCard(
            icon: Icons.warning_rounded,
            title: 'Low Stock',
            count: lowStockCount,
            color: Colors.orange,
            onTap: () {},
          ),
        ],
        if (expiringSoonCount > 0) ...[
          if (lowStockCount > 0 || outOfStockCount > 0)
            const SizedBox(height: 8),
          _AlertCard(
            icon: Icons.schedule_rounded,
            title: 'Expiring Soon',
            count: expiringSoonCount,
            color: Colors.amber,
            onTap: () {},
          ),
        ],
      ],
    );
  }
}

class _MobileSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String change;
  final Color changeColor;
  final Gradient gradient;
  final Color iconColor;
  final Color textColor;

  const _MobileSummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
    required this.gradient,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _AlertCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$count $title Items',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
