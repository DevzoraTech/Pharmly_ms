class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String category;
  final String? imageUrl;
  final DateTime expiryDate;
  final String manufacturer;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.category,
    this.imageUrl,
    required this.expiryDate,
    required this.manufacturer,
    this.isActive = true,
  });

  bool get isLowStock => stockQuantity <= 10;
  bool get isOutOfStock => stockQuantity <= 0;
  bool get isExpiringSoon => expiryDate.difference(DateTime.now()).inDays <= 30;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stockQuantity: json['stockQuantity'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      expiryDate: DateTime.parse(json['expiryDate']),
      manufacturer: json['manufacturer'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'category': category,
      'imageUrl': imageUrl,
      'expiryDate': expiryDate.toIso8601String(),
      'manufacturer': manufacturer,
      'isActive': isActive,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    String? category,
    String? imageUrl,
    DateTime? expiryDate,
    String? manufacturer,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturer: manufacturer ?? this.manufacturer,
      isActive: isActive ?? this.isActive,
    );
  }
}
