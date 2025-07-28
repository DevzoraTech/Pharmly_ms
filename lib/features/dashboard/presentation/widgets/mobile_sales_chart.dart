import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/providers/order_provider.dart';
import '../../../../core/theme/app_theme.dart';

class MobileSalesChart extends StatefulWidget {
  const MobileSalesChart({super.key});

  @override
  State<MobileSalesChart> createState() => _MobileSalesChartState();
}

class _MobileSalesChartState extends State<MobileSalesChart> {
  String selectedPeriod = 'This Year';
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final salesData =
            orderProvider.monthlySales
                .map((data) => data['sales'] as double)
                .toList();

        if (salesData.isEmpty) {
          return const Center(child: Text('No sales data available'));
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with period selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sales Analytics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      underline: const SizedBox.shrink(),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'This Year',
                          child: Text('This Year'),
                        ),
                        DropdownMenuItem(
                          value: 'Last Year',
                          child: Text('Last Year'),
                        ),
                        DropdownMenuItem(
                          value: 'This Month',
                          child: Text('This Month'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPeriod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Chart container
              Container(
                height: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _calculateInterval(salesData),
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
                            return _buildBottomTitle(value.toInt());
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: _calculateInterval(salesData),
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return _buildLeftTitle(value);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (salesData.length - 1).toDouble(),
                    minY: 0,
                    maxY: salesData.reduce((a, b) => a > b ? a : b) * 1.1,
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
                              radius: touchedIndex == index ? 8 : 5,
                              color:
                                  touchedIndex == index
                                      ? AppTheme.accentColor
                                      : AppTheme.primaryColor,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.primaryColor.withValues(alpha: 0.3),
                              AppTheme.primaryColor.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (
                        FlTouchEvent event,
                        LineTouchResponse? touchResponse,
                      ) {
                        setState(() {
                          if (touchResponse != null &&
                              touchResponse.lineBarSpots != null) {
                            touchedIndex =
                                touchResponse.lineBarSpots!.first.spotIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AppTheme.primaryColor,
                        tooltipBorder: BorderSide.none,
                        tooltipPadding: const EdgeInsets.all(8),
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          return touchedBarSpots.map((barSpot) {
                            return LineTooltipItem(
                              '\$${barSpot.y.toStringAsFixed(0)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Legend and insights
              _buildInsights(salesData),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomTitle(int index) {
    const months = [
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

    if (index >= 0 && index < months.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          months[index],
          style: TextStyle(
            color: touchedIndex == index ? AppTheme.primaryColor : Colors.grey,
            fontSize: 12,
            fontWeight:
                touchedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLeftTitle(double value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        value >= 1000
            ? '\$${(value / 1000).toStringAsFixed(0)}k'
            : '\$${value.toInt()}',
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  double _calculateInterval(List<double> data) {
    if (data.isEmpty) return 1000;
    final max = data.reduce((a, b) => a > b ? a : b);
    return max / 5;
  }

  Widget _buildInsights(List<double> salesData) {
    final currentMonth = salesData.isNotEmpty ? salesData.last : 0;
    final previousMonth =
        salesData.length > 1 ? salesData[salesData.length - 2] : 0;
    final growth =
        previousMonth > 0
            ? ((currentMonth - previousMonth) / previousMonth * 100)
            : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Month',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${currentMonth.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Growth',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      growth >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: growth >= 0 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${growth.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: growth >= 0 ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
