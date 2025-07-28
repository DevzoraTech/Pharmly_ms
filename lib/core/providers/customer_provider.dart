import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';

enum CustomerLoadingStatus { initial, loading, loaded, error }

class CustomerProvider extends ChangeNotifier {
  final CustomerService _customerService;

  List<Customer> _customers = [];
  CustomerLoadingStatus _status = CustomerLoadingStatus.initial;
  String? _error;

  CustomerProvider({required CustomerService customerService})
    : _customerService = customerService;

  List<Customer> get customers => _customers;
  CustomerLoadingStatus get status => _status;
  String? get error => _error;

  int get totalCustomers => _customers.length;

  List<Customer> get topCustomersByLoyalty {
    final sortedCustomers = List<Customer>.from(_customers)
      ..sort((a, b) => b.loyaltyPoints.compareTo(a.loyaltyPoints));
    return sortedCustomers.take(5).toList();
  }

  Map<String, int> get customerRegistrationByMonth {
    return _customerService.getCustomerRegistrationByMonth();
  }

  Future<void> loadCustomers() async {
    _status = CustomerLoadingStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await _customerService.getCustomers();

      if (response.success) {
        _customers = response.data ?? [];
        _status = CustomerLoadingStatus.loaded;
      } else {
        _error = response.error ?? 'Failed to load customers';
        _status = CustomerLoadingStatus.error;
      }
    } catch (e) {
      _error = e.toString();
      _status = CustomerLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<bool> addCustomer(Customer customer) async {
    try {
      final response = await _customerService.createCustomer(customer);

      if (response.success) {
        _customers.add(response.data!);
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

  Future<bool> updateCustomer(Customer customer) async {
    try {
      final response = await _customerService.updateCustomer(customer);

      if (response.success) {
        final index = _customers.indexWhere((c) => c.id == customer.id);
        if (index != -1) {
          _customers[index] = response.data!;
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

  Future<bool> deleteCustomer(String id) async {
    try {
      final response = await _customerService.deleteCustomer(id);

      if (response.success) {
        _customers.removeWhere((c) => c.id == id);
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

  Future<bool> addLoyaltyPoints(String id, int points) async {
    final index = _customers.indexWhere((c) => c.id == id);
    if (index == -1) {
      _error = 'Customer not found';
      notifyListeners();
      return false;
    }

    final customer = _customers[index];
    final updatedCustomer = customer.copyWith(
      loyaltyPoints: customer.loyaltyPoints + points,
    );

    return updateCustomer(updatedCustomer);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
