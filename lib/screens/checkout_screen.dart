import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'credit_card';
  bool _isProcessing = false;
  late double _subtotal;
  late double _tax;
  late double _total;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _subtotal = args['subtotal'] as double;
      _tax = args['tax'] as double;
      _total = args['total'] as double;
    } else {
      // Default values if not provided
      _subtotal = 800.0;
      _tax = 40.0;
      _total = 840.0;
    }
  }
  
  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }
  
  void _placeOrder() {
    setState(() {
      _isProcessing = true;
    });
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });
      
      // Show success message and navigate to home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('checkout.payment_success')),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // Navigate to home screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('checkout.checkout'),
          style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.festiveGradient,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Checkout form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment method section
                    Text(
                      localizations.translate('checkout.payment_method'),
                      style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Credit Card option
                    _buildPaymentOption(
                      'credit_card',
                      localizations.translate('checkout.credit_card'),
                      Icons.credit_card,
                      isArabic,
                    ),
                    const SizedBox(height: 12),
                    
                    // Apple Pay option
                    _buildPaymentOption(
                      'apple_pay',
                      localizations.translate('checkout.apple_pay'),
                      Icons.apple,
                      isArabic,
                    ),
                    const SizedBox(height: 12),
                    
                    // Google Pay option
                    _buildPaymentOption(
                      'google_pay',
                      localizations.translate('checkout.google_pay'),
                      Icons.g_mobiledata,
                      isArabic,
                    ),
                    const SizedBox(height: 12),
                    
                    // Samsung Pay option
                    _buildPaymentOption(
                      'samsung_pay',
                      localizations.translate('checkout.samsung_pay'),
                      Icons.phone_android,
                      isArabic,
                    ),
                    const SizedBox(height: 32),
                    
                    // Order summary section
                    Text(
                      localizations.translate('checkout.order_summary'),
                      style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Order summary card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Subtotal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localizations.translate('cart.subtotal'),
                                  style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                ),
                                Text(
                                  '\$${_subtotal.toStringAsFixed(2)}',
                                  style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Tax
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localizations.translate('cart.tax'),
                                  style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                ),
                                Text(
                                  '\$${_tax.toStringAsFixed(2)}',
                                  style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            
                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localizations.translate('cart.total'),
                                  style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
                                ),
                                Text(
                                  '\$${_total.toStringAsFixed(2)}',
                                  style: (isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4).copyWith(
                                    color: AppTheme.festiveColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Place order button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _placeOrder,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          localizations.translate('checkout.place_order'),
                          style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPaymentOption(String value, String title, IconData icon, bool isArabic) {
    final isSelected = _selectedPaymentMethod == value;
    
    return InkWell(
      onTap: () => _selectPaymentMethod(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.festiveColor : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppTheme.festiveColor.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.festiveColor : AppTheme.textSecondary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: (isArabic ? AppTheme.body1Arabic : AppTheme.body1).copyWith(
                color: isSelected ? AppTheme.festiveColor : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.festiveColor,
              ),
          ],
        ),
      ),
    );
  }
}
