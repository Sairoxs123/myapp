import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  User? get currentUser => _currentUser;

  AuthService() {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // --- Authentication Methods ---

  Future<UserCredential?> logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // _currentUser will be updated by the authStateChanges listener
      return userCredential;
    } on FirebaseAuthException {
      rethrow; // Re-throw the exception for UI to handle
    } catch (e) {
      rethrow; // Re-throw other unexpected errors
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      user?.updateDisplayName(name);
      await user?.sendEmailVerification();
      return userCredential;
    } on FirebaseAuthException {
      rethrow; // Re-throw the exception for UI to handle
    } catch (e) {
      rethrow; // Re-throw other unexpected errors
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // _currentUser will be set to null by the authStateChanges listener
  }

  // You can add more methods here like:
  // Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async { ... }
  // Future<void> sendPasswordResetEmail(String email) async { ... }
}
