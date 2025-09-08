import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_app/data/models/user_model.dart';
import 'package:task_management_app/data/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AuthState _authState = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get authState => _authState;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated =>
      _authState == AuthState.authenticated && _currentUser != null;

  // Initialize auth state
  Future<void> initializeAuth() async {
    _setLoading(true);

    try {
      // Check for cached user first
      _currentUser = await _authRepository.getCachedUser();

      // Check current Firebase user
      final firebaseUser = _authRepository.getCurrentUser();
      if (firebaseUser != null) {
        _currentUser = firebaseUser;
        _setAuthState(AuthState.authenticated);
      } else {
        _setAuthState(AuthState.unauthenticated);
      }

      // Listen to auth state changes
      _authRepository.authStateChanges.listen((user) {
        if (user != null) {
          _currentUser = user;
          _setAuthState(AuthState.authenticated);
        } else {
          _currentUser = null;
          _setAuthState(AuthState.unauthenticated);
        }
      });
    } catch (e) {
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        _setAuthState(AuthState.authenticated);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_authRepository.getErrorMessage(e));
      return false;
    } catch (e) {
      _setError('Google sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Email Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signInWithEmail(email, password);
      _currentUser = user;
      _setAuthState(AuthState.authenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_authRepository.getErrorMessage(e));
      return false;
    } catch (e) {
      _setError('Email sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Email Sign Up
  Future<bool> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signUpWithEmail(email, password);
      _currentUser = user;
      _setAuthState(AuthState.authenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_authRepository.getErrorMessage(e));
      return false;
    } catch (e) {
      _setError('Email sign-up failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _setAuthState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Private methods
  void _setAuthState(AuthState state) {
    _authState = state;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _authState = AuthState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }
}
