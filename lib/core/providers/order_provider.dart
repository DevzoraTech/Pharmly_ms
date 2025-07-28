import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

enum OrderLoadingStatus { initial, loading, loaded, error }

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;

  List<Order> _orders = [];
  OrderLoadingStatus _status = OrderLoadingStatus.initial;
  String? _error;

  OrderProvider({required OrderService orderService})
    : _orderService = orderService;

  List<Order> get orders => _orders;
  OrderLoadingStatus get status => _status;
  String? get error => _error;

  List<Order> get recentOrders {
    final sortedOrders = List<Order>.from(_orders)
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return sortedOrders.take(10).toList();
  }

  Map<OrderStatus, int> get orderCountByStatus {
    final Map<OrderStatus, int> result = {};

    for (final order in _orders) {
      if (result.containsKey(order.status)) {
        result[order.status] = result[order.status]! + 1;
      } else {
        result[order.status] = 1;
      }
    }

    return result;
  }

  double get totalSales {
    return _orders
        .where((order) => order.paymentStatus == PaymentStatus.completed)
        .fold(0, (sum, order) => sum + order.totalAmount);
  }

  List<Map<String, dynamic>> get monthlySales {
    return _orderService.getMonthlySales();
  }

  Future<void> loadOrders() async {
    _status = OrderLoadingStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await _orderService.getOrders();

      if (response.success) {
        _orders = response.data ?? [];
        _status = OrderLoadingStatus.loaded;
      } else {
        _error = response.error ?? 'Failed to load orders';
        _status = OrderLoadingStatus.error;
      }
    } catch (e) {
      _error = e.toString();
      _status = OrderLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<bool> addOrder(Order order) async {
    try {
      final response = await _orderService.createOrder(order);

      if (response.success) {
        _orders.add(response.data!);
        notifyListeners();
        return true;
      } else {
        _error = response.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrder(Order order) async {
    try {
      final response = await _orderService.updateOrder(order);

      if (response.success) {
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = response.data!;
          notifyListeners();
        }
        return true;
      } else {
        _error = response.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteOrder(String id) async {
    try {
      final response = await _orderService.deleteOrder(id);

      if (response.success) {
        _orders.removeWhere((o) => o.id == id);
        notifyListeners();
        return true;
      } else {
        _error = response.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrderStatus(String id, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) {
      _error = 'Order not found';
      notifyListeners();
      return false;
    }

    final updatedOrder = _orders[index].copyWith(status: status);
    return updateOrder(updatedOrder);
  }

  Future<bool> updatePaymentStatus(String id, PaymentStatus status) async {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) {
      _error = 'Order not found';
      notifyListeners();
      return false;
    }

    final updatedOrder = _orders[index].copyWith(paymentStatus: status);
    return updateOrder(updatedOrder);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
