class Customer {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final DateTime registrationDate;
  final int loyaltyPoints;
  final List<String> orderIds;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.registrationDate,
    this.loyaltyPoints = 0,
    this.orderIds = const [],
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      registrationDate: DateTime.parse(json['registrationDate']),
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
      orderIds: List<String>.from(json['orderIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'registrationDate': registrationDate.toIso8601String(),
      'loyaltyPoints': loyaltyPoints,
      'orderIds': orderIds,
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? registrationDate,
    int? loyaltyPoints,
    List<String>? orderIds,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      registrationDate: registrationDate ?? this.registrationDate,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      orderIds: orderIds ?? this.orderIds,
    );
  }
}
