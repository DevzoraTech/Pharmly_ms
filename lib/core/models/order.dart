import 'package:intl/intl.dart';

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}

enum OrderStatus { pending, processing, delivered, cancelled }

enum PaymentStatus { pending, completed, failed, refunded }

class Order {
  final String id;
  final String customerId;
  final String customerName;
  final List<OrderItem> items;
  final DateTime orderDate;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final double totalAmount;
  final String? notes;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.orderDate,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    this.notes,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(orderDate);
  String get formattedTime => DateFormat('hh:mm a').format(orderDate);
  String get statusText => status.toString().split('.').last;
  String get paymentStatusText => paymentStatus.toString().split('.').last;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      items:
          (json['items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      totalAmount: json['totalAmount'].toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'items': items.map((item) => item.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'totalAmount': totalAmount,
      'notes': notes,
    };
  }

  Order copyWith({
    String? id,
    String? customerId,
    String? customerName,
    List<OrderItem>? items,
    DateTime? orderDate,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    double? totalAmount,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      items: items ?? this.items,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
    );
  }
}
