import '../models/order.dart';
import '../models/product.dart';
import '../models/customer.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class OrderService {
  final ApiService _apiService;
  final bool useMockData;
  List<Order> _mockOrders = [];
  List<Product> _mockProducts = [];
  List<Customer> _mockCustomers = [];

  OrderService({required ApiService apiService, this.useMockData = true})
    : _apiService = apiService {
    if (useMockData) {
      _mockProducts = MockDataService.generateProducts(50);
      _mockCustomers = MockDataService.generateCustomers(20);
      _mockOrders = MockDataService.generateOrders(
        _mockProducts,
        _mockCustomers,
        30,
      );
    }
  }

  Future<ApiResponse<List<Order>>> getOrders() async {
    if (useMockData) {
      return ApiResponse(data: _mockOrders, success: true);
    }

    return _apiService.getList<Order>('orders', (json) => Order.fromJson(json));
  }

  Future<ApiResponse<Order>> getOrder(String id) async {
    if (useMockData) {
      final order = _mockOrders.firstWhere(
        (o) => o.id == id,
        orElse: () => throw Exception('Order not found'),
      );

      return ApiResponse(data: order, success: true);
    }

    return _apiService.get<Order>('orders/$id', (json) => Order.fromJson(json));
  }

  Future<ApiResponse<Order>> createOrder(Order order) async {
    if (useMockData) {
      _mockOrders.add(order);

      return ApiResponse(data: order, success: true);
    }

    return _apiService.post<Order>(
      'orders',
      order.toJson(),
      (json) => Order.fromJson(json),
    );
  }

  Future<ApiResponse<Order>> updateOrder(Order order) async {
    if (useMockData) {
      final index = _mockOrders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _mockOrders[index] = order;

        return ApiResponse(data: order, success: true);
      }

      return ApiResponse(error: 'Order not found', success: false);
    }

    return _apiService.put<Order>(
      'orders/${order.id}',
      order.toJson(),
      (json) => Order.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteOrder(String id) async {
    if (useMockData) {
      final initialLength = _mockOrders.length;
      _mockOrders.removeWhere((o) => o.id == id);
      final removed = _mockOrders.length < initialLength;

      return ApiResponse(data: removed, success: removed);
    }

    return _apiService.delete('orders/$id');
  }

  List<Order> getRecentOrders({int limit = 10}) {
    final sortedOrders = List<Order>.from(_mockOrders)
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));

    return sortedOrders.take(limit).toList();
  }

  Map<OrderStatus, int> getOrderCountByStatus() {
    final Map<OrderStatus, int> result = {};

    for (final order in _mockOrders) {
      if (result.containsKey(order.status)) {
        result[order.status] = result[order.status]! + 1;
      } else {
        result[order.status] = 1;
      }
    }

    return result;
  }

  double getTotalSales() {
    return _mockOrders
        .where((order) => order.paymentStatus == PaymentStatus.completed)
        .fold(0, (sum, order) => sum + order.totalAmount);
  }

  List<Map<String, dynamic>> getMonthlySales() {
    final Map<String, double> monthlySales = {};
    final now = DateTime.now();

    // Initialize with last 12 months
    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      monthlySales[monthKey] = 0;
    }

    // Aggregate sales by month
    for (final order in _mockOrders) {
      if (order.paymentStatus == PaymentStatus.completed) {
        final monthKey =
            '${order.orderDate.year}-${order.orderDate.month.toString().padLeft(2, '0')}';
        if (monthlySales.containsKey(monthKey)) {
          monthlySales[monthKey] = monthlySales[monthKey]! + order.totalAmount;
        }
      }
    }

    // Convert to list format for charts
    return monthlySales.entries.map((entry) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final date = DateTime(year, month);

      return {'month': date.month, 'year': date.year, 'sales': entry.value};
    }).toList();
  }
}
