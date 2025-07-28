import 'package:flutter/material.dart';
import '../../../../core/models/order.dart';

class LatestOrdersTable extends StatelessWidget {
  final List<Order> orders;

  const LatestOrdersTable({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF163D35),
                    textStyle: const TextStyle(fontSize: 13),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 18,
                headingRowHeight: 36,
                dataRowHeight: 44,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
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
                      'Customer',
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
                              DataCell(Text(order.id)),
                              DataCell(Text(order.customerName)),
                              DataCell(
                                Text(
                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                ),
                              ),
                              DataCell(
                                _OrderStatusBadge(status: order.statusText),
                              ),
                              DataCell(
                                _OrderStatusBadge(
                                  status: order.paymentStatusText,
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_horiz, size: 20),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
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
