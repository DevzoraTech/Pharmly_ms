import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, authenticating }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;

  AuthProvider({required AuthService authService})
    : _authService = authService {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      _user = user;
      _status =
          user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });

    // Initialize status based on current user
    _user = _authService.currentUser;
    _status =
        _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    final response = await _authService.login(email, password);

    if (response.success) {
      _user = response.data;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _error = response.error ?? 'Authentication failed';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    final response = await _authService.register(name, email, password);

    if (response.success) {
      _user = response.data;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _error = response.error ?? 'Registration failed';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(User updatedUser) async {
    final response = await _authService.updateProfile(updatedUser);

    if (response.success) {
      _user = response.data;
      notifyListeners();
      return true;
    } else {
      _error = response.error ?? 'Profile update failed';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
