import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'icon': Icons.event,
      'title_en': 'Welcome to Eventify',
      'title_ar': 'مرحبًا بك في إيفنتفاي',
      'description_en': 'Your one-stop solution for all event planning needs',
      'description_ar': 'حلك الشامل لجميع احتياجات تخطيط المناسبات',
      'color': Color(0xFF8E44AD),
    },
    {
      'icon': Icons.people,
      'title_en': 'Find the Best Service Providers',
      'title_ar': 'ابحث عن أفضل مزودي الخدمات',
      'description_en': 'Connect with top-rated photographers, decorators, caterers and more',
      'description_ar': 'تواصل مع أفضل المصورين والمزينين ومقدمي الطعام والمزيد',
      'color': Color(0xFFE91E63),
    },
    {
      'icon': Icons.shopping_cart,
      'title_en': 'Book Services with Ease',
      'title_ar': 'احجز الخدمات بسهولة',
      'description_en': 'Browse, select and book services all in one place',
      'description_ar': 'تصفح واختر واحجز الخدمات في مكان واحد',
      'color': Color(0xFF00BCD4),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _skipOnboarding() {
    // Navigate to login screen
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    isArabic ? 'تخطي' : 'Skip',
                    style: TextStyle(
                      color: AppTheme.festiveColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: isArabic ? 'Tajawal' : 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
            
            // Onboarding content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    _onboardingData[index]['icon'] as IconData,
                    isArabic
                        ? _onboardingData[index]['title_ar'] as String
                        : _onboardingData[index]['title_en'] as String,
                    isArabic
                        ? _onboardingData[index]['description_ar'] as String
                        : _onboardingData[index]['description_en'] as String,
                    _onboardingData[index]['color'] as Color,
                    isArabic,
                  );
                },
              ),
            ),
            
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppTheme.festiveColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToNextPage,
                  child: Text(
                    _currentPage < _onboardingData.length - 1
                        ? localizations.translate('general.continue')
                        : localizations.translate('general.done'),
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
  
  Widget _buildOnboardingPage(
    IconData icon,
    String title,
    String description,
    Color color,
    bool isArabic,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: color,
            ),
          ),
          const SizedBox(height: 40),
          
          // Title
          Text(
            title,
            style: isArabic ? AppTheme.headingH1Arabic : AppTheme.headingH1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            description,
            style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
