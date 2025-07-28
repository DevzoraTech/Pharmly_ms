import '../models/product.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class ProductService {
  final ApiService _apiService;
  final bool useMockData;
  List<Product> _mockProducts = [];

  ProductService({required ApiService apiService, this.useMockData = true})
    : _apiService = apiService {
    if (useMockData) {
      _mockProducts = MockDataService.generateProducts(50);
    }
  }

  Future<ApiResponse<List<Product>>> getProducts() async {
    if (useMockData) {
      return ApiResponse(data: _mockProducts, success: true);
    }

    return _apiService.getList<Product>(
      'products',
      (json) => Product.fromJson(json),
    );
  }

  Future<ApiResponse<Product>> getProduct(String id) async {
    if (useMockData) {
      final product = _mockProducts.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Product not found'),
      );

      return ApiResponse(data: product, success: true);
    }

    return _apiService.get<Product>(
      'products/$id',
      (json) => Product.fromJson(json),
    );
  }

  Future<ApiResponse<Product>> createProduct(Product product) async {
    if (useMockData) {
      _mockProducts.add(product);

      return ApiResponse(data: product, success: true);
    }

    return _apiService.post<Product>(
      'products',
      product.toJson(),
      (json) => Product.fromJson(json),
    );
  }

  Future<ApiResponse<Product>> updateProduct(Product product) async {
    if (useMockData) {
      final index = _mockProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _mockProducts[index] = product;

        return ApiResponse(data: product, success: true);
      }

      return ApiResponse(error: 'Product not found', success: false);
    }

    return _apiService.put<Product>(
      'products/${product.id}',
      product.toJson(),
      (json) => Product.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteProduct(String id) async {
    if (useMockData) {
      final initialLength = _mockProducts.length;
      _mockProducts.removeWhere((p) => p.id == id);
      final removed = _mockProducts.length < initialLength;

      return ApiResponse(data: removed, success: removed);
    }

    return _apiService.delete('products/$id');
  }

  List<Product> getLowStockProducts() {
    return _mockProducts.where((p) => p.isLowStock).toList();
  }

  List<Product> getOutOfStockProducts() {
    return _mockProducts.where((p) => p.isOutOfStock).toList();
  }

  List<Product> getExpiringSoonProducts() {
    return _mockProducts.where((p) => p.isExpiringSoon).toList();
  }

  Map<String, int> getProductCountByCategory() {
    final Map<String, int> result = {};

    for (final product in _mockProducts) {
      if (result.containsKey(product.category)) {
        result[product.category] = result[product.category]! + 1;
      } else {
        result[product.category] = 1;
      }
    }

    return result;
  }
}
