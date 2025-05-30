import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userType = 'user'; // 'user' or 'provider'
  String _phoneNumber = '';
  String _userId = '';
  String _verificationId = '';
  bool _isLoading = false;
  String _error = '';
  
  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;
  String get phoneNumber => _phoneNumber;
  String get userId => _userId;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Constructor - check if user is already logged in
  MockAuthProvider() {
    _checkLoginStatus();
  }
  
  // Check if user is already logged in from shared preferences
  Future<void> _checkLoginStatus() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (_isLoggedIn) {
        _userType = prefs.getString('userType') ?? 'user';
        _phoneNumber = prefs.getString('phoneNumber') ?? '';
        _userId = prefs.getString('userId') ?? '';
      }
    } catch (e) {
      _setError('Failed to load login status: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Send verification code to phone number (mocked for web preview)
  Future<bool> sendVerificationCode(String phoneNumber) async {
    _setLoading(true);
    _setError('');
    try {
      // Store phone number for later use
      _phoneNumber = phoneNumber;
      
      // Generate a fake verification ID
      _verificationId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to send verification code: $e');
      _setLoading(false);
      return false;
    }
  }
  
  // Verify the code entered by user (mocked for web preview)
  Future<bool> verifyCode(String code, String userType) async {
    _setLoading(true);
    _setError('');
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For web preview, accept any 6-digit code
      if (code.length != 6) {
        _setError('Invalid verification code. Please enter a 6-digit code.');
        _setLoading(false);
        return false;
      }
      
      // Set user as logged in
      _isLoggedIn = true;
      _userType = userType;
      
      // Generate a fake user ID
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      
      // Save login status to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userType', userType);
      await prefs.setString('phoneNumber', _phoneNumber);
      await prefs.setString('userId', _userId);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to verify code: $e');
      _setLoading(false);
      return false;
    }
  }
  
  // Update user profile (mocked for web preview)
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
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
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
