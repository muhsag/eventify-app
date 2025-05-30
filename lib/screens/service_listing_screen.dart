import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class ServiceListingScreen extends StatefulWidget {
  const ServiceListingScreen({super.key});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  late Map<String, dynamic> _category;
  final List<Map<String, dynamic>> _providers = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('category')) {
      _category = args['category'] as Map<String, dynamic>;
      
      // Generate providers based on category
      _generateProviders();
    } else {
      // Default category if not provided
      _category = {
        'name_key': 'categories.photography',
        'icon': Icons.camera_alt,
        'color': AppTheme.photographyColor,
      };
      _generateProviders();
    }
  }
  
  void _generateProviders() {
    // Clear existing providers
    _providers.clear();
    
    // Generate sample providers based on category
    final categoryKey = _category['name_key'] as String;
    
    if (categoryKey == 'categories.photography') {
      _providers.addAll([
        {
          'name': 'Emily Warren',
          'rating': 4.9,
          'price': 500,
          'image': 'assets/images/provider_profile_english.png',
        },
        {
          'name': 'Michael Scott',
          'rating': 4.7,
          'price': 450,
          'image': 'assets/images/provider_profile_english.png',
        },
        {
          'name': 'Jessica Chen',
          'rating': 4.8,
          'price': 550,
          'image': 'assets/images/provider_profile_english.png',
        },
      ]);
    } else if (categoryKey == 'categories.decoration') {
      _providers.addAll([
        {
          'name': 'Megan White',
          'rating': 4.7,
          'price': 300,
          'image': 'assets/images/provider_profile_english.png',
        },
        {
          'name': 'David Kim',
          'rating': 4.5,
          'price': 350,
          'image': 'assets/images/provider_profile_english.png',
        },
      ]);
    } else {
      // Default providers for other categories
      _providers.addAll([
        {
          'name': 'Service Provider 1',
          'rating': 4.5,
          'price': 400,
          'image': 'assets/images/provider_profile_english.png',
        },
        {
          'name': 'Service Provider 2',
          'rating': 4.3,
          'price': 350,
          'image': 'assets/images/provider_profile_english.png',
        },
      ]);
    }
  }
  
  void _viewProviderProfile(int index) {
    Navigator.pushNamed(
      context,
      AppRoutes.serviceProviderProfile,
      arguments: {
        'provider': {
          'name': _providers[index]['name'],
          'rating': _providers[index]['rating'],
          'category_key': _category['name_key'],
          'image': _providers[index]['image'],
          'color': _category['color'],
          'bio': 'Professional service provider offering quality services for your events.',
        },
      },
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
          localizations.translate(_category['name_key']),
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
            // Filters
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: Text(
                        localizations.translate('general.filter'),
                        style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sort),
                      label: Text(
                        localizations.translate('general.sort'),
                        style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Provider list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  final provider = _providers[index];
                  return GestureDetector(
                    onTap: () => _viewProviderProfile(index),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Provider image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              provider['image'],
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Provider name
                                Text(
                                  provider['name'],
                                  style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
                                ),
                                const SizedBox(height: 8),
                                
                                // Rating
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppTheme.warningColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${provider['rating']}',
                                      style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                
                                // Price
                                Row(
                                  children: [
                                    Text(
                                      '${localizations.translate('service.price')}: ',
                                      style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                    ),
                                    Text(
                                      '\$${provider['price']}',
                                      style: (isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4).copyWith(
                                        color: AppTheme.festiveColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // View profile button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _viewProviderProfile(index),
                                    child: Text(
                                      localizations.translate('general.view_profile'),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
