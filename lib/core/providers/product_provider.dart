import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

enum ProductLoadingStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductService _productService;

  List<Product> _products = [];
  ProductLoadingStatus _status = ProductLoadingStatus.initial;
  String? _error;

  ProductProvider({required ProductService productService})
    : _productService = productService;

  List<Product> get products => _products;
  ProductLoadingStatus get status => _status;
  String? get error => _error;

  List<Product> get lowStockProducts =>
      _products
          .where((product) => product.isLowStock && !product.isOutOfStock)
          .toList();

  List<Product> get outOfStockProducts =>
      _products.where((product) => product.isOutOfStock).toList();

  List<Product> get expiringSoonProducts =>
      _products.where((product) => product.isExpiringSoon).toList();

  Map<String, int> get productCountByCategory {
    final Map<String, int> result = {};

    for (final product in _products) {
      if (result.containsKey(product.category)) {
        result[product.category] = result[product.category]! + 1;
      } else {
        result[product.category] = 1;
      }
    }

    return result;
  }

  Future<void> loadProducts() async {
    _status = ProductLoadingStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await _productService.getProducts();

      if (response.success) {
        _products = response.data ?? [];
        _status = ProductLoadingStatus.loaded;
      } else {
        _error = response.error ?? 'Failed to load products';
        _status = ProductLoadingStatus.error;
      }
    } catch (e) {
      _error = e.toString();
      _status = ProductLoadingStatus.error;
    }

    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    try {
      final response = await _productService.createProduct(product);

      if (response.success) {
        _products.add(response.data!);
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

  Future<bool> updateProduct(Product product) async {
    try {
      final response = await _productService.updateProduct(product);

      if (response.success) {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = response.data!;
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

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await _productService.deleteProduct(id);

      if (response.success) {
        _products.removeWhere((p) => p.id == id);
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
