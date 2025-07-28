import '../models/customer.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class CustomerService {
  final ApiService _apiService;
  final bool useMockData;
  List<Customer> _mockCustomers = [];

  CustomerService({required ApiService apiService, this.useMockData = true})
    : _apiService = apiService {
    if (useMockData) {
      _mockCustomers = MockDataService.generateCustomers(20);
    }
  }

  Future<ApiResponse<List<Customer>>> getCustomers() async {
    if (useMockData) {
      return ApiResponse(data: _mockCustomers, success: true);
    }

    return _apiService.getList<Customer>(
      'customers',
      (json) => Customer.fromJson(json),
    );
  }

  Future<ApiResponse<Customer>> getCustomer(String id) async {
    if (useMockData) {
      final customer = _mockCustomers.firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('Customer not found'),
      );

      return ApiResponse(data: customer, success: true);
    }

    return _apiService.get<Customer>(
      'customers/$id',
      (json) => Customer.fromJson(json),
    );
  }

  Future<ApiResponse<Customer>> createCustomer(Customer customer) async {
    if (useMockData) {
      _mockCustomers.add(customer);

      return ApiResponse(data: customer, success: true);
    }

    return _apiService.post<Customer>(
      'customers',
      customer.toJson(),
      (json) => Customer.fromJson(json),
    );
  }

  Future<ApiResponse<Customer>> updateCustomer(Customer customer) async {
    if (useMockData) {
      final index = _mockCustomers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _mockCustomers[index] = customer;

        return ApiResponse(data: customer, success: true);
      }

      return ApiResponse(error: 'Customer not found', success: false);
    }

    return _apiService.put<Customer>(
      'customers/${customer.id}',
      customer.toJson(),
      (json) => Customer.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteCustomer(String id) async {
    if (useMockData) {
      final initialLength = _mockCustomers.length;
      _mockCustomers.removeWhere((c) => c.id == id);
      final removed = _mockCustomers.length < initialLength;

      return ApiResponse(data: removed, success: removed);
    }

    return _apiService.delete('customers/$id');
  }

  int getTotalCustomers() {
    return _mockCustomers.length;
  }

  List<Customer> getTopCustomersByLoyalty({int limit = 5}) {
    final sortedCustomers = List<Customer>.from(_mockCustomers)
      ..sort((a, b) => b.loyaltyPoints.compareTo(a.loyaltyPoints));

    return sortedCustomers.take(limit).toList();
  }

  Map<String, int> getCustomerRegistrationByMonth() {
    final Map<String, int> result = {};
    final now = DateTime.now();

    // Initialize with last 12 months
    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      result[monthKey] = 0;
    }

    // Count registrations by month
    for (final customer in _mockCustomers) {
      final monthKey =
          '${customer.registrationDate.year}-${customer.registrationDate.month.toString().padLeft(2, '0')}';
      if (result.containsKey(monthKey)) {
        result[monthKey] = result[monthKey]! + 1;
      }
    }

    return result;
  }
}
