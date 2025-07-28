import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';

class SalesAnalyticsChart extends StatelessWidget {
  final List<double> salesData;
  final int highlightedIndex;

  const SalesAnalyticsChart({
    super.key,
    required this.salesData,
    this.highlightedIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Handle empty data
    if (salesData.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No sales data available')),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sales Analytics',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: 'This Year',
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: 'This Year',
                      child: Text('This Year'),
                    ),
                    DropdownMenuItem(
                      value: 'Last Year',
                      child: Text('Last Year'),
                    ),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 &&
                              index < months.length &&
                              index < salesData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                months[index],
                                style: TextStyle(
                                  color:
                                      index == highlightedIndex
                                          ? AppTheme.primaryColor
                                          : Colors.grey,
                                  fontWeight:
                                      index == highlightedIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5000,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '\$${(value / 1000).toStringAsFixed(0)}k',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (salesData.length - 1).toDouble(),
                  minY: 0,
                  maxY:
                      salesData.isNotEmpty
                          ? salesData.reduce((a, b) => a > b ? a : b) * 1.2
                          : 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        salesData.length,
                        (index) => FlSpot(index.toDouble(), salesData[index]),
                      ),
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: index == highlightedIndex ? 6 : 4,
                            color:
                                index == highlightedIndex
                                    ? AppTheme.accentColor
                                    : AppTheme.primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryColor.withValues(
                          alpha: 51,
                        ), // 0.2 * 255 = ~51
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  color: AppTheme.primaryColor,
                  label: 'Current Year',
                ),
                const SizedBox(width: 24),
                _LegendItem(
                  color: Colors.grey.shade400,
                  label: 'Previous Year',
                  isDashed: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({
    super.key,
    required this.color,
    required this.label,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child:
              isDashed
                  ? LayoutBuilder(
                    builder: (context, constraints) {
                      return Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          (constraints.constrainWidth() / 4).floor(),
                          (index) =>
                              Container(width: 2, height: 3, color: color),
                        ),
                      );
                    },
                  )
                  : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
