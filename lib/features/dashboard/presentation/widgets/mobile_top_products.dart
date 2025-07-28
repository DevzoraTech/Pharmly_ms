import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/providers/product_provider.dart';
import '../../../../core/theme/app_theme.dart';

class MobileTopProducts extends StatefulWidget {
  const MobileTopProducts({super.key});

  @override
  State<MobileTopProducts> createState() => _MobileTopProductsState();
}

class _MobileTopProductsState extends State<MobileTopProducts> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products.take(6).toList();

        if (products.isEmpty) {
          return const Center(child: Text('No products available'));
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View All'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Chart and legend
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Pie Chart
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (
                              FlTouchEvent event,
                              pieTouchResponse,
                            ) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex =
                                    pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: _generatePieChartSections(products),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Legend
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            products.asMap().entries.map((entry) {
                              final index = entry.key;
                              final product = entry.value;
                              return _buildLegendItem(
                                index,
                                product.name,
                                _getProductColor(index),
                                product.stockQuantity,
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Product list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildProductCard(product, index),
                  );
                },
              ),
              const SizedBox(height: 60), // Extra bottom padding
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _generatePieChartSections(List products) {
    final total = products.fold<int>(
      0,
      (sum, product) => sum + (product.stockQuantity as int),
    );

    return products.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 65.0 : 55.0;
      final percentage = (product.stockQuantity / total * 100).toStringAsFixed(
        1,
      );

      return PieChartSectionData(
        color: _getProductColor(index),
        value: product.stockQuantity.toDouble(),
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getProductColor(int index) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.accentColor,
      Colors.blue.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.teal.shade600,
    ];
    return colors[index % colors.length];
  }

  Widget _buildLegendItem(int index, String name, Color color, int stock) {
    final isSelected = index == touchedIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product, int index) {
    final color = _getProductColor(index);
    final stockStatus = _getStockStatus(product.stockQuantity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.medication_rounded, color: color, size: 24),
          ),
          const SizedBox(width: 16),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.category,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: stockStatus['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        stockStatus['text'],
                        style: TextStyle(
                          color: stockStatus['color'],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            color: Colors.grey.shade600,
            tooltip: 'More options',
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStockStatus(int stock) {
    if (stock == 0) {
      return {'text': 'Out of Stock', 'color': Colors.red};
    } else if (stock <= 10) {
      return {'text': 'Low Stock ($stock)', 'color': Colors.orange};
    } else {
      return {'text': 'In Stock ($stock)', 'color': Colors.green};
    }
  }
}
