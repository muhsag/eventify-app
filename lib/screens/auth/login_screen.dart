import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _login() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    
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
          'userType': 'user', // Default to user for login
          'name': '',
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

  void _navigateToRegistration() {
    Navigator.pushNamed(context, AppRoutes.registration);
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('auth.login'),
          style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
        ),
      ),
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
                  
                  // Login heading
                  Text(
                    localizations.translate('auth.login'),
                    style: isArabic ? AppTheme.headingH1Arabic : AppTheme.headingH1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    localizations.translate('auth.login_description'),
                    style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
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
                  
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _login,
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
                              localizations.translate('auth.login'),
                              style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Don't have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('auth.dont_have_account'),
                        style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                      ),
                      TextButton(
                        onPressed: _navigateToRegistration,
                        child: Text(
                          localizations.translate('auth.create_account'),
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
