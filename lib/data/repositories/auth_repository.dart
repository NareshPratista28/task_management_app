import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/core/Services/auth_service.dart';
import 'package:task_management_app/data/models/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  static const String _userKey = 'cached_user';

  // Get Current User
  UserModel? getCurrentUser() {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      return UserModel.fromFirebaseUser(firebaseUser);
    }
    return null;
  }

  // Auth state stream
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    });
  }

  // Google Sign In
  Future<UserModel?> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential?.user != null) {
        final userModel = UserModel.fromFirebaseUser(userCredential!.user!);
        await _cacheUser(userModel);
        return userModel;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Email Sign In
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _authService.signInWithEmailPassword(
        email,
        password,
      );
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);
      await _cacheUser(userModel);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  // Email Sign Up
  Future<UserModel> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _authService.signUpWithEmailPassword(
        email,
        password,
      );
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);
      await _cacheUser(userModel);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _clearCachedUser();
    } catch (e) {
      rethrow;
    }
  }

  // Cache user locally
  Future<void> _cacheUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      // Handle caching error silently
    }
  }

  // Get cached user
  Future<UserModel?> getCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return UserModel.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Clear cached user
  Future<void> _clearCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      // Handle error silently
    }
  }

  // Get error message
  String getErrorMessage(dynamic error) {
    return _authService.getErrorMessage(error);
  }
}
