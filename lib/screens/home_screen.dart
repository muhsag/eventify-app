import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    // Check if user is logged in
    if (!authProvider.isLoggedIn) {
      // Redirect to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      });
      
      // Show loading screen while redirecting
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // List of screens to display based on bottom navigation
    final screens = [
      _buildHomeContent(context, isArabic, localizations),
      _buildCategoriesContent(context, isArabic, localizations),
      _buildCartContent(context, isArabic, localizations),
      _buildProfileContent(context, isArabic, localizations),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eventify',
          style: AppTheme.headingH4.copyWith(
            color: AppTheme.festiveColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Toggle language
              appLanguage.changeLanguage(
                isArabic ? const Locale('en') : const Locale('ar'),
              );
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.festiveColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.translate('navigation.home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category),
            label: localizations.translate('navigation.categories'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: localizations.translate('navigation.cart'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.translate('navigation.profile'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHomeContent(BuildContext context, bool isArabic, AppLocalizations localizations) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                localizations.translate('home.welcome_message'),
                style: isArabic ? AppTheme.headingH2Arabic : AppTheme.headingH2,
              ),
              const SizedBox(height: 24),
              
              // Featured services
              _buildSectionHeader(
                localizations.translate('home.featured_services'),
                isArabic,
                onSeeAllPressed: () {
                  setState(() {
                    _currentIndex = 1; // Switch to categories tab
                  });
                },
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildFeaturedServiceCard(
                      context,
                      index,
                      isArabic,
                      localizations,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              // Popular categories
              _buildSectionHeader(
                localizations.translate('home.popular_categories'),
                isArabic,
                onSeeAllPressed: () {
                  setState(() {
                    _currentIndex = 1; // Switch to categories tab
                  });
                },
              ),
              const SizedBox(height: 16),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(
                    context,
                    index,
                    isArabic,
                    localizations,
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Recent orders
              _buildSectionHeader(
                localizations.translate('home.recent_orders'),
                isArabic,
              ),
              const SizedBox(height: 16),
              
              // Show recent orders or empty state
              _buildRecentOrdersList(context, isArabic, localizations),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoriesContent(BuildContext context, bool isArabic, AppLocalizations localizations) {
    // List of categories
    final categories = [
      {
        'icon': Icons.photo_camera,
        'name': localizations.translate('categories.photography'),
        'color': Colors.blue,
      },
      {
        'icon': Icons.celebration,
        'name': localizations.translate('categories.decoration'),
        'color': Colors.pink,
      },
      {
        'icon': Icons.restaurant,
        'name': localizations.translate('categories.catering'),
        'color': Colors.orange,
      },
      {
        'icon': Icons.local_bar,
        'name': localizations.translate('categories.beverages'),
        'color': Colors.purple,
      },
      {
        'icon': Icons.cake,
        'name': localizations.translate('categories.sweets'),
        'color': Colors.red,
      },
      {
        'icon': Icons.event,
        'name': localizations.translate('categories.event_planning'),
        'color': Colors.teal,
      },
    ];
    
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories title
              Text(
                localizations.translate('categories.title'),
                style: isArabic ? AppTheme.headingH2Arabic : AppTheme.headingH2,
              ),
              const SizedBox(height: 8),
              
              // Categories description
              Text(
                localizations.translate('categories.description'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              const SizedBox(height: 24),
              
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: localizations.translate('categories.search'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Categories grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCardDetailed(
                    context,
                    categories[index]['icon'] as IconData,
                    categories[index]['name'] as String,
                    categories[index]['color'] as Color,
                    isArabic,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCartContent(BuildContext context, bool isArabic, AppLocalizations localizations) {
    // Empty cart state
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.translate('cart.empty_cart'),
              style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.translate('cart.empty_cart_description'),
              style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 1; // Switch to categories tab
                });
              },
              child: Text(
                localizations.translate('cart.browse_services'),
                style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileContent(BuildContext context, bool isArabic, AppLocalizations localizations) {
    // Navigate to profile screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, AppRoutes.userProfile);
    });
    
    // Show loading while navigating
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  Widget _buildSectionHeader(String title, bool isArabic, {VoidCallback? onSeeAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
        ),
        if (onSeeAllPressed != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: Text(
              AppLocalizations.of(context).translate('general.see_all'),
              style: TextStyle(
                color: AppTheme.festiveColor,
                fontWeight: FontWeight.bold,
                fontFamily: isArabic ? 'Tajawal' : 'Poppins',
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildFeaturedServiceCard(
    BuildContext context,
    int index,
    bool isArabic,
    AppLocalizations localizations,
  ) {
    // Sample featured services
    final services = [
      {
        'name': localizations.translate('services.wedding_photography'),
        'provider': 'John Smith',
        'price': '\$500',
        'rating': 4.8,
      },
      {
        'name': localizations.translate('services.birthday_decoration'),
        'provider': 'Sarah Johnson',
        'price': '\$300',
        'rating': 4.5,
      },
      {
        'name': localizations.translate('services.corporate_catering'),
        'provider': 'Michael Brown',
        'price': '\$450',
        'rating': 4.7,
      },
      {
        'name': localizations.translate('services.wedding_planning'),
        'provider': 'Emma Wilson',
        'price': '\$800',
        'rating': 4.9,
      },
      {
        'name': localizations.translate('services.custom_cake'),
        'provider': 'David Lee',
        'price': '\$150',
        'rating': 4.6,
      },
    ];
    
    final service = services[index];
    
    return GestureDetector(
      onTap: () {
        // Navigate to service provider profile
        Navigator.pushNamed(context, AppRoutes.serviceProviderProfile);
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.festiveColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  index % 2 == 0 ? Icons.photo_camera : Icons.celebration,
                  size: 40,
                  color: AppTheme.festiveColor,
                ),
              ),
            ),
            
            // Service details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: isArabic ? 'Tajawal' : 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['provider'] as String,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: isArabic ? 'Tajawal' : 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service['price'] as String,
                        style: TextStyle(
                          color: AppTheme.festiveColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: isArabic ? 'Tajawal' : 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service['rating'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: isArabic ? 'Tajawal' : 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryCard(
    BuildContext context,
    int index,
    bool isArabic,
    AppLocalizations localizations,
  ) {
    // Sample categories
    final categories = [
      {
        'name': localizations.translate('categories.photography'),
        'icon': Icons.photo_camera,
        'color': Colors.blue,
      },
      {
        'name': localizations.translate('categories.decoration'),
        'icon': Icons.celebration,
        'color': Colors.pink,
      },
      {
        'name': localizations.translate('categories.catering'),
        'icon': Icons.restaurant,
        'color': Colors.orange,
      },
      {
        'name': localizations.translate('categories.event_planning'),
        'icon': Icons.event,
        'color': Colors.teal,
      },
    ];
    
    final category = categories[index];
    
    return GestureDetector(
      onTap: () {
        // Navigate to service listing
        Navigator.pushNamed(context, AppRoutes.serviceListing);
      },
      child: Container(
        decoration: BoxDecoration(
          color: category['color'] as Color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'] as IconData,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              category['name'] as String,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: isArabic ? 'Tajawal' : 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryCardDetailed(
    BuildContext context,
    IconData icon,
    String name,
    Color color,
    bool isArabic,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to service listing
        Navigator.pushNamed(context, AppRoutes.serviceListing);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: isArabic ? 'Tajawal' : 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).translate('general.view_all'),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontFamily: isArabic ? 'Tajawal' : 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentOrdersList(BuildContext context, bool isArabic, AppLocalizations localizations) {
    // Empty state for recent orders
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.translate('home.no_recent_orders'),
            style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentIndex = 1; // Switch to categories tab
              });
            },
            child: Text(
              localizations.translate('home.browse_services'),
              style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
