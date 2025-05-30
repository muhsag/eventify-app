import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoggedIn = false;
  String _userType = 'user'; // 'user' or 'provider'
  String _phoneNumber = '';
  String _userId = '';
  String _verificationId = '';
  bool _isLoading = false;
  String _error = '';
  int? _resendToken;
  
  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;
  String get phoneNumber => _phoneNumber;
  String get userId => _userId;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Constructor - check if user is already logged in
  AuthProvider() {
    _checkLoginStatus();
  }
  
  // Check if user is already logged in from Firebase Auth
  Future<void> _checkLoginStatus() async {
    _setLoading(true);
    try {
      // Check Firebase Auth state
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        _isLoggedIn = true;
        _userId = currentUser.uid;
        _phoneNumber = currentUser.phoneNumber ?? '';
        
        // Get user type from Firestore
        final userDoc = await _firestore.collection('users').doc(_userId).get();
        if (userDoc.exists) {
          _userType = userDoc.data()?['userType'] ?? 'user';
        }
      } else {
        // No user is signed in
        _isLoggedIn = false;
        
        // Clear shared preferences as fallback
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('isLoggedIn');
        await prefs.remove('userType');
        await prefs.remove('phoneNumber');
        await prefs.remove('userId');
      }
    } catch (e) {
      _setError('Failed to load login status: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Send verification code to phone number
  Future<bool> sendVerificationCode(String phoneNumber) async {
    _setLoading(true);
    _setError('');
    try {
      // Store phone number for later use
      _phoneNumber = phoneNumber;
      
      // Send verification code using Firebase Auth
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setLoading(false);
          if (e.code == 'invalid-phone-number') {
            _setError('Invalid phone number format');
          } else {
            _setError('Verification failed: ${e.message}');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
      
      return true;
    } catch (e) {
      _setError('Failed to send verification code: $e');
      _setLoading(false);
      return false;
    }
  }
  
  // Verify the code entered by user
  Future<bool> verifyCode(String code, String userType) async {
    _setLoading(true);
    _setError('');
    try {
      // Create credential with verification ID and code
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      
      // Update user type
      _userType = userType;
      
      // Sign in with credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user != null) {
        _isLoggedIn = true;
        _userId = user.uid;
        
        // Create or update user document in Firestore
        await _firestore.collection('users').doc(_userId).set({
          'phoneNumber': _phoneNumber,
          'userType': _userType,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Save login status to shared preferences as backup
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userType', _userType);
        await prefs.setString('phoneNumber', _phoneNumber);
        await prefs.setString('userId', _userId);
        
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to sign in');
        _setLoading(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-verification-code':
          errorMessage = 'Invalid verification code';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Invalid verification session';
          break;
        default:
          errorMessage = 'Verification failed: ${e.message}';
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to verify code: $e');
      _setLoading(false);
      return false;
    }
  }
  
  // Sign in with credential (for auto-verification)
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user != null) {
        _isLoggedIn = true;
        _userId = user.uid;
        
        // Create or update user document in Firestore
        await _firestore.collection('users').doc(_userId).set({
          'phoneNumber': _phoneNumber,
          'userType': _userType,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Save login status to shared preferences as backup
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userType', _userType);
        await prefs.setString('phoneNumber', _phoneNumber);
        await prefs.setString('userId', _userId);
        
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to sign in: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Update user profile
  Future<bool> updateUserProfile({
    required String name,
    String? email,
    String? profileImageUrl,
  }) async {
    _setLoading(true);
    _setError('');
    try {
      if (!_isLoggedIn || _userId.isEmpty) {
        _setError('User not logged in');
        _setLoading(false);
        return false;
      }
      
      // Update user document in Firestore
      await _firestore.collection('users').doc(_userId).update({
        'name': name,
        if (email != null) 'email': email,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      _setLoading(false);
      return false;
    }
  }
  
  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    try {
      // Sign out from Firebase Auth
      await _auth.signOut();
      
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userType');
      await prefs.remove('phoneNumber');
      await prefs.remove('userId');
      
      // Reset state
      _isLoggedIn = false;
      _userType = 'user';
      _phoneNumber = '';
      _userId = '';
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to logout: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Update user type
  void updateUserType(String userType) {
    _userType = userType;
    notifyListeners();
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
