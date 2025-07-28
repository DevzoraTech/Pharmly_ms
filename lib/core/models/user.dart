enum UserRole { admin, pharmacist, cashier }

class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final UserRole role;
  final bool isActive;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.isActive = true,
    required this.lastLogin,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isPharmacist => role == UserRole.pharmacist;
  bool get isCashier => role == UserRole.cashier;

  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.cashier,
      ),
      isActive: json['isActive'] ?? true,
      lastLogin: DateTime.parse(json['lastLogin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role.toString().split('.').last,
      'isActive': isActive,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    bool? isActive,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
