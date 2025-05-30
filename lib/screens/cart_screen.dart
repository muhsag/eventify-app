import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Wedding Photography',
      'provider': 'Emily Warren',
      'price': 500,
      'image': 'assets/images/provider_profile_english.png',
    },
    {
      'id': '2',
      'name': 'Event Decoration',
      'provider': 'Megan White',
      'price': 300,
      'image': 'assets/images/provider_profile_english.png',
    },
  ];
  
  double get _subtotal => _cartItems.fold(0, (sum, item) => sum + (item['price'] as num));
  double get _tax => _subtotal * 0.05;
  double get _total => _subtotal + _tax;
  
  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate('cart.remove')),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }
  
  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('cart.empty_cart')),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }
    
    Navigator.pushNamed(
      context,
      AppRoutes.checkout,
      arguments: {
        'subtotal': _subtotal,
        'tax': _tax,
        'total': _total,
      },
    );
  }
  
  void _continueShopping() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('cart.my_cart'),
          style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.festiveGradient,
          ),
        ),
      ),
      body: SafeArea(
        child: _cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate('cart.empty_cart'),
                      style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _continueShopping,
                      child: Text(
                        localizations.translate('cart.continue_shopping'),
                        style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Cart items list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item['image'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Item details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['provider'],
                                        style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '\$${item['price']}',
                                        style: (isArabic ? AppTheme.headingH5Arabic : AppTheme.headingH5).copyWith(
                                          color: AppTheme.festiveColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Remove button
                                IconButton(
                                  onPressed: () => _removeItem(index),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppTheme.errorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Order summary
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
                        const SizedBox(height: 16),
                        
                        // Checkout button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _proceedToCheckout,
                            child: Text(
                              localizations.translate('cart.checkout'),
                              style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
