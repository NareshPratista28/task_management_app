import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  // Stream untuk auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Initialize Google Sign-In
  Future<void> initializeGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize();
    } catch (e) {
      // Log error untuk development, silent untuk production
      if (kDebugMode) {
        debugPrint('Google Sign-In initialization failed: $e');
      }
      // Tidak throw error karena app masih bisa jalan tanpa Google Sign-In
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Log untuk debugging jika diperlukan
      if (kDebugMode) {
        debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      }
      // Re-throw FirebaseAuthException supaya bisa di-handle di UI layer
      rethrow;
    } catch (e) {
      // Log unexpected errors
      if (kDebugMode) {
        debugPrint('Unexpected sign-in error: $e');
      }
      // Convert ke FirebaseAuthException untuk konsistensi
      throw FirebaseAuthException(
        code: 'sign-in-failed',
        message: 'Sign-in failed',
      );
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected sign-up error: $e');
      }
      throw FirebaseAuthException(
        code: 'sign-up-failed',
        message: 'Sign-up failed',
      );
    }
  }

  // Google Sign-In Method (v7.0+ compatible)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Check if platform supports authenticate
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw FirebaseAuthException(
          code: 'google-sign-in-not-supported',
          message: 'Google Sign-In not supported on this platform',
        );
      }

      // Authenticate with Google
      final GoogleSignInAccount? gUser = await GoogleSignIn.instance
          .authenticate(scopeHint: ['email', 'profile']);

      if (gUser == null) {
        // User cancelled, return null (bukan error)
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Validate tokens
      if (gAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-google-id-token',
          message: 'Failed to get Google ID token',
        );
      }

      // Create Firebase credential using only idToken
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Log FirebaseAuth errors untuk debugging
      if (kDebugMode) {
        debugPrint(
          'Firebase Auth Error in Google Sign-In: ${e.code} - ${e.message}',
        );
      }
      rethrow;
    } catch (e) {
      // Log unexpected errors
      if (kDebugMode) {
        debugPrint('Unexpected Google Sign-In error: $e');
      }
      // Convert ke FirebaseAuthException
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Google Sign-In failed',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _firebaseAuth.signOut();

      // Sign out from Google - jangan throw error jika gagal
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        // Log warning tapi jangan throw
        if (kDebugMode) {
          debugPrint('Google sign out warning: $e');
        }
      }
    } catch (e) {
      // Log error tapi jangan throw - user sudah logout dari Firebase
      if (kDebugMode) {
        debugPrint('Sign out error: $e');
      }
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('Password reset error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected password reset error: $e');
      }
      throw FirebaseAuthException(
        code: 'password-reset-failed',
        message: 'Failed to send password reset email',
      );
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('Profile update error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected profile update error: $e');
      }
      throw FirebaseAuthException(
        code: 'profile-update-failed',
        message: 'Failed to update profile',
      );
    }
  }

  // Get user-friendly error message
  String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled.';
        case 'account-exists-with-different-credential':
          return 'Account exists with different sign-in method.';
        case 'invalid-credential':
          return 'Invalid credentials provided.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'google-sign-in-not-supported':
          return 'Google Sign-In is not supported on this device.';
        case 'missing-google-id-token':
          return 'Google authentication failed. Please try again.';
        case 'google-sign-in-failed':
          return 'Google Sign-In failed. Please try again.';
        case 'sign-in-failed':
          return 'Sign-in failed. Please try again.';
        case 'sign-up-failed':
          return 'Sign-up failed. Please try again.';
        case 'password-reset-failed':
          return 'Failed to send password reset email.';
        case 'no-current-user':
          return 'No user is currently signed in.';
        case 'profile-update-failed':
          return 'Failed to update profile.';
        default:
          return error.message ?? 'An error occurred. Please try again.';
      }
    }

    // For non-FirebaseAuthException errors
    return 'An unexpected error occurred. Please try again.';
  }

  // Check if user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  // Get current user info
  Map<String, dynamic>? getCurrentUserInfo() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'emailVerified': user.emailVerified,
        'isAnonymous': user.isAnonymous,
      };
    }
    return null;
  }
}
