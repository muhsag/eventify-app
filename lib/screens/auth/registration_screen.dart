import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/auth_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedUserType = 'user'; // 'user' or 'provider'

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _continueRegistration() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    
    // Update user type in provider
    authProvider.updateUserType(_selectedUserType);
    
    // Send verification code
    final success = await authProvider.sendVerificationCode(_phoneController.text);
    
    if (success) {
      // Navigate to phone verification screen
      if (!mounted) return;
      Navigator.pushNamed(
        context, 
        AppRoutes.phoneVerification,
        arguments: {
          'phone': _phoneController.text,
          'userType': _selectedUserType,
          'name': _nameController.text,
        },
      );
    } else {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error.isNotEmpty 
              ? authProvider.error 
              : localizations.translate('errors.general')),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // Logo and app name
                  const Icon(
                    Icons.celebration,
                    color: AppTheme.festiveColor,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Eventify',
                    style: AppTheme.headingH1.copyWith(
                      color: AppTheme.festiveColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Create Account heading
                  Text(
                    localizations.translate('auth.create_account'),
                    style: isArabic ? AppTheme.headingH1Arabic : AppTheme.headingH1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // User type selection
                  Text(
                    localizations.translate('auth.select_account_type'),
                    style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedUserType = 'user';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedUserType == 'user'
                                ? AppTheme.festiveColor
                                : Colors.white,
                            foregroundColor: _selectedUserType == 'user'
                                ? Colors.white
                                : AppTheme.festiveColor,
                            elevation: 0,
                            side: BorderSide(
                              color: _selectedUserType == 'user'
                                  ? Colors.transparent
                                  : AppTheme.festiveColor,
                            ),
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(
                            localizations.translate('auth.register_user'),
                            style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedUserType = 'provider';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedUserType == 'provider'
                                ? AppTheme.festiveColor
                                : Colors.white,
                            foregroundColor: _selectedUserType == 'provider'
                                ? Colors.white
                                : AppTheme.festiveColor,
                            elevation: 0,
                            side: BorderSide(
                              color: _selectedUserType == 'provider'
                                  ? Colors.transparent
                                  : AppTheme.festiveColor,
                            ),
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(
                            localizations.translate('auth.register_provider'),
                            style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Name input
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: localizations.translate('auth.full_name'),
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('errors.required_field');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone number input
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: localizations.translate('auth.phone_number'),
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: '+1234567890',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('errors.required_field');
                      }
                      // Basic phone validation
                      if (value.length < 8) {
                        return localizations.translate('errors.invalid_phone');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _continueRegistration,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              localizations.translate('general.continue'),
                              style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('auth.already_have_account'),
                        style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                      ),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: Text(
                          localizations.translate('auth.login'),
                          style: (isArabic ? AppTheme.body2Arabic : AppTheme.body2).copyWith(
                            color: AppTheme.festiveColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
