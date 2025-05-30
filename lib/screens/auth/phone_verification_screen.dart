import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/auth_provider.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _phoneNumber;
  late String _userType;
  late String _name;
  bool _isResendingCode = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    // Start countdown for resend button
    _startResendCountdown();
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        
        if (_resendCountdown > 0) {
          _startResendCountdown();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _phoneNumber = args['phone'] as String;
      _userType = args['userType'] as String;
      _name = args['name'] as String? ?? '';
    } else {
      _phoneNumber = '';
      _userType = 'user';
      _name = '';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    
    // Verify code
    final success = await authProvider.verifyCode(_codeController.text, _userType);
    
    if (success) {
      // Update user profile with name if provided
      if (_name.isNotEmpty) {
        await authProvider.updateUserProfile(name: _name);
      }
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('auth.verification_success')),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // Navigate to home screen
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } else {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error.isNotEmpty 
              ? authProvider.error 
              : localizations.translate('errors.verification_failed')),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _resendCode() async {
    if (!_canResend) return;
    
    setState(() {
      _isResendingCode = true;
    });
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    
    // Resend verification code
    final success = await authProvider.sendVerificationCode(_phoneNumber);
    
    setState(() {
      _isResendingCode = false;
    });
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('auth.verification_sent')),
          backgroundColor: AppTheme.infoColor,
        ),
      );
      
      // Reset countdown
      _startResendCountdown();
    } else {
      // Show error message
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

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('auth.verification_code'),
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
                  
                  // Verification icon
                  const Icon(
                    Icons.verified_user,
                    color: AppTheme.festiveColor,
                    size: 80,
                  ),
                  const SizedBox(height: 32),
                  
                  // Instructions
                  Text(
                    localizations.translate('auth.enter_verification_code'),
                    style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Phone number
                  Text(
                    _phoneNumber,
                    style: (isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3).copyWith(
                      color: AppTheme.festiveColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Verification code input
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: AppTheme.headingH3,
                    decoration: InputDecoration(
                      hintText: '000000',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('errors.required_field');
                      }
                      if (value.length != 6) {
                        return localizations.translate('errors.invalid_code');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _verifyCode,
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
                  
                  // Resend code
                  _isResendingCode
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      : _canResend
                          ? TextButton(
                              onPressed: _resendCode,
                              child: Text(
                                localizations.translate('auth.resend_code'),
                                style: (isArabic ? AppTheme.body2Arabic : AppTheme.body2).copyWith(
                                  color: AppTheme.festiveColor,
                                ),
                              ),
                            )
                          : Text(
                              '${localizations.translate('auth.resend_code_in')} $_resendCountdown ${localizations.translate('general.seconds')}',
                              style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                            ),
                  
                  // Network error message
                  if (authProvider.error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        authProvider.error,
                        style: (isArabic ? AppTheme.body2Arabic : AppTheme.body2).copyWith(
                          color: AppTheme.errorColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
