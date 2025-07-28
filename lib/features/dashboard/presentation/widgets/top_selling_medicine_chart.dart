import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';

class TopMedicine {
  final String name;
  final double sales;
  final Color color;
  final String emoji;

  const TopMedicine({
    required this.name,
    required this.sales,
    required this.color,
    required this.emoji,
  });
}

class TopSellingMedicineChart extends StatelessWidget {
  final List<TopMedicine> medicines;

  const TopSellingMedicineChart({Key? key, required this.medicines})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalSales = medicines.fold(
      0.0,
      (sum, medicine) => sum + medicine.sales,
    );

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
                  'Top Selling Medicines',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: 'This Month',
                  underline: const SizedBox.shrink(),
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
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections:
                      medicines.map((medicine) {
                        final percentage = medicine.sales / totalSales;
                        return PieChartSectionData(
                          color: medicine.color,
                          value: medicine.sales,
                          title: '${(percentage * 100).toStringAsFixed(0)}%',
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...medicines.map((medicine) => _MedicineItem(medicine: medicine)),
          ],
        ),
      ),
    );
  }
}

class _MedicineItem extends StatelessWidget {
  final TopMedicine medicine;

  const _MedicineItem({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: medicine.color.withValues(alpha: 30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(medicine.emoji, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${medicine.sales.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: medicine.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
