import 'dart:math';
import '../models/product.dart';
import '../models/order.dart';
import '../models/customer.dart';
import '../models/user.dart';

class MockDataService {
  static final Random _random = Random();

  // Product Categories
  static final List<String> _productCategories = [
    'Antibiotics',
    'Pain Relievers',
    'Vitamins & Supplements',
    'Antiviral Drugs',
    'Diabetes Care',
    'Cardiovascular',
    'Allergy Medication',
    'Respiratory Medicines',
  ];

  // Manufacturers
  static final List<String> _manufacturers = [
    'Pfizer',
    'Johnson & Johnson',
    'Roche',
    'Novartis',
    'Merck',
    'GlaxoSmithKline',
    'Sanofi',
    'AbbVie',
  ];

  // Product Names
  static final Map<String, List<String>> _productNames = {
    'Antibiotics': [
      'Amoxicillin',
      'Azithromycin',
      'Ciprofloxacin',
      'Doxycycline',
      'Penicillin',
    ],
    'Pain Relievers': [
      'Ibuprofen',
      'Acetaminophen',
      'Naproxen',
      'Aspirin',
      'Diclofenac',
    ],
    'Vitamins & Supplements': [
      'Vitamin C',
      'Vitamin D3',
      'Multivitamin',
      'Omega-3',
      'Calcium',
    ],
    'Antiviral Drugs': [
      'Acyclovir',
      'Oseltamivir',
      'Ribavirin',
      'Valacyclovir',
      'Zanamivir',
    ],
    'Diabetes Care': [
      'Metformin',
      'Insulin',
      'Glipizide',
      'Sitagliptin',
      'Glyburide',
    ],
    'Cardiovascular': [
      'Atorvastatin',
      'Lisinopril',
      'Metoprolol',
      'Amlodipine',
      'Warfarin',
    ],
    'Allergy Medication': [
      'Cetirizine',
      'Loratadine',
      'Fexofenadine',
      'Diphenhydramine',
      'Desloratadine',
    ],
    'Respiratory Medicines': [
      'Albuterol',
      'Fluticasone',
      'Montelukast',
      'Budesonide',
      'Tiotropium',
    ],
  };

  // Generate a random product
  static Product generateProduct() {
    final category =
        _productCategories[_random.nextInt(_productCategories.length)];
    final productName =
        _productNames[category]![_random.nextInt(
          _productNames[category]!.length,
        )];
    final manufacturer = _manufacturers[_random.nextInt(_manufacturers.length)];

    return Product(
      id: 'PRD${_random.nextInt(10000).toString().padLeft(4, '0')}',
      name: productName,
      description: 'This is a description for $productName',
      price: double.parse((_random.nextDouble() * 100 + 5).toStringAsFixed(2)),
      stockQuantity: _random.nextInt(100),
      category: category,
      expiryDate: DateTime.now().add(Duration(days: _random.nextInt(365) + 30)),
      manufacturer: manufacturer,
    );
  }

  // Generate a list of random products
  static List<Product> generateProducts(int count) {
    return List.generate(count, (index) => generateProduct());
  }

  // Generate a random customer
  static Customer generateCustomer() {
    final id = 'CUS${_random.nextInt(10000).toString().padLeft(4, '0')}';
    final names = [
      'John Doe',
      'Jane Smith',
      'Robert Johnson',
      'Emily Davis',
      'Michael Wilson',
    ];
    final name = names[_random.nextInt(names.length)];
    final email = '${name.split(' ')[0].toLowerCase()}@example.com';

    return Customer(
      id: id,
      name: name,
      email: email,
      phone:
          '+1${_random.nextInt(900) + 100}${_random.nextInt(900) + 100}${_random.nextInt(9000) + 1000}',
      address: '${_random.nextInt(999) + 1} Main St, City',
      registrationDate: DateTime.now().subtract(
        Duration(days: _random.nextInt(365)),
      ),
      loyaltyPoints: _random.nextInt(1000),
    );
  }

  // Generate a list of random customers
  static List<Customer> generateCustomers(int count) {
    return List.generate(count, (index) => generateCustomer());
  }

  // Generate a random order
  static Order generateOrder(
    List<Product> availableProducts,
    List<Customer> availableCustomers,
  ) {
    final customer =
        availableCustomers[_random.nextInt(availableCustomers.length)];
    final itemCount = _random.nextInt(5) + 1;
    final orderItems = <OrderItem>[];
    double totalAmount = 0;

    // Select random products for this order
    final selectedProducts = List.generate(
      itemCount,
      (_) => availableProducts[_random.nextInt(availableProducts.length)],
    );

    for (final product in selectedProducts) {
      final quantity = _random.nextInt(3) + 1;
      final orderItem = OrderItem(
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        unitPrice: product.price,
      );
      orderItems.add(orderItem);
      totalAmount += orderItem.totalPrice;
    }

    final orderStatuses = OrderStatus.values;
    final paymentStatuses = PaymentStatus.values;

    return Order(
      id: 'ORD${_random.nextInt(10000).toString().padLeft(4, '0')}',
      customerId: customer.id,
      customerName: customer.name,
      items: orderItems,
      orderDate: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
      status: orderStatuses[_random.nextInt(orderStatuses.length)],
      paymentStatus: paymentStatuses[_random.nextInt(paymentStatuses.length)],
      totalAmount: totalAmount,
    );
  }

  // Generate a list of random orders
  static List<Order> generateOrders(
    List<Product> availableProducts,
    List<Customer> availableCustomers,
    int count,
  ) {
    return List.generate(
      count,
      (index) => generateOrder(availableProducts, availableCustomers),
    );
  }

  // Generate a random user
  static User generateUser() {
    final roles = UserRole.values;
    final names = [
      'Admin User',
      'Pharmacist One',
      'Cashier One',
      'Manager User',
    ];
    final name = names[_random.nextInt(names.length)];

    return User(
      id: 'USR${_random.nextInt(1000).toString().padLeft(3, '0')}',
      name: name,
      email: '${name.split(' ')[0].toLowerCase()}@pharmly.com',
      role: roles[_random.nextInt(roles.length)],
      lastLogin: DateTime.now().subtract(Duration(hours: _random.nextInt(24))),
    );
  }

  // Generate a list of random users
  static List<User> generateUsers(int count) {
    return List.generate(count, (index) => generateUser());
  }

  // Get mock data for the entire application
  static Map<String, dynamic> getMockData() {
    final products = generateProducts(50);
    final customers = generateCustomers(20);
    final orders = generateOrders(products, customers, 30);
    final users = generateUsers(5);

    return {
      'products': products,
      'customers': customers,
      'orders': orders,
      'users': users,
    };
  }
}
