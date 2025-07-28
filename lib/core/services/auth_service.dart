import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'mock_data_service.dart';

class AuthService {
  final ApiService _apiService;
  final bool useMockData;
  User? _currentUser;
  List<User> _mockUsers = [];

  // Stream controller for auth state changes
  final _authStateController = StreamController<User?>.broadcast();
  Stream<User?> get authStateChanges => _authStateController.stream;

  AuthService({required ApiService apiService, this.useMockData = true})
    : _apiService = apiService {
    if (useMockData) {
      _mockUsers = MockDataService.generateUsers(5);
      // Ensure we have one admin user
      _mockUsers.add(
        User(
          id: 'USR001',
          name: 'Admin User',
          email: 'admin@pharmly.com',
          role: UserRole.admin,
          lastLogin: DateTime.now(),
        ),
      );
    }

    // Try to restore session
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null && useMockData) {
      try {
        final user = _mockUsers.firstWhere((u) => u.id == userId);
        _currentUser = user;
        _authStateController.add(user);
      } catch (e) {
        // User not found, clear preferences
        await prefs.remove('user_id');
        await prefs.remove('auth_token');
      }
    }
  }

  Future<ApiResponse<User>> login(String email, String password) async {
    if (useMockData) {
      try {
        // In mock mode, any password works, just match the email
        final user = _mockUsers.firstWhere((u) => u.email == email);

        // Save to preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.id);
        await prefs.setString('auth_token', 'mock_token_${user.id}');

        _currentUser = user;
        _authStateController.add(user);

        return ApiResponse(data: user, success: true);
      } catch (e) {
        return ApiResponse(error: 'Invalid email or password', success: false);
      }
    }

    final response = await _apiService.post<Map<String, dynamic>>(
      'auth/login',
      {'email': email, 'password': password},
      (json) => json,
    );

    if (response.success && response.data != null) {
      final userData = response.data!;
      final user = User.fromJson(userData['user']);
      final token = userData['token'];

      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      await prefs.setString('auth_token', token);

      _currentUser = user;
      _authStateController.add(user);

      return ApiResponse(data: user, success: true);
    }

    return ApiResponse(error: response.error ?? 'Login failed', success: false);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('auth_token');

    _currentUser = null;
    _authStateController.add(null);
  }

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<ApiResponse<User>> register(
    String name,
    String email,
    String password,
  ) async {
    if (useMockData) {
      // Check if email already exists
      if (_mockUsers.any((u) => u.email == email)) {
        return ApiResponse(error: 'Email already in use', success: false);
      }

      final newUser = User(
        id: 'USR${_mockUsers.length + 1}',
        name: name,
        email: email,
        role: UserRole.cashier, // Default role for new users
        lastLogin: DateTime.now(),
      );

      _mockUsers.add(newUser);

      // Auto login after registration
      return login(email, password);
    }

    final response = await _apiService.post<Map<String, dynamic>>(
      'auth/register',
      {'name': name, 'email': email, 'password': password},
      (json) => json,
    );

    if (response.success && response.data != null) {
      // Auto login after registration
      return login(email, password);
    }

    return ApiResponse(
      error: response.error ?? 'Registration failed',
      success: false,
    );
  }

  Future<ApiResponse<User>> updateProfile(User updatedUser) async {
    if (useMockData) {
      if (_currentUser == null) {
        return ApiResponse(error: 'Not authenticated', success: false);
      }

      final index = _mockUsers.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _mockUsers[index] = updatedUser;
        _currentUser = updatedUser;
        _authStateController.add(updatedUser);

        return ApiResponse(data: updatedUser, success: true);
      }

      return ApiResponse(error: 'User not found', success: false);
    }

    final response = await _apiService.put<User>(
      'auth/profile',
      updatedUser.toJson(),
      (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      _currentUser = response.data;
      _authStateController.add(_currentUser);
    }

    return response;
  }

  void dispose() {
    _authStateController.close();
  }
}
