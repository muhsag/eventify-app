import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class ServiceProviderProfileScreen extends StatefulWidget {
  const ServiceProviderProfileScreen({super.key});

  @override
  State<ServiceProviderProfileScreen> createState() => _ServiceProviderProfileScreenState();
}

class _ServiceProviderProfileScreenState extends State<ServiceProviderProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _provider;
  
  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Wedding Photography',
      'price': 500,
      'image': 'assets/images/provider_profile_english.png',
    },
    {
      'name': 'Engagement Photography',
      'price': 300,
      'image': 'assets/images/provider_profile_english.png',
    },
    {
      'name': 'Party Photography',
      'price': 200,
      'image': 'assets/images/provider_profile_english.png',
    },
  ];
  
  final List<String> _portfolioImages = [
    'assets/images/provider_profile_english.png',
    'assets/images/provider_profile_english.png',
    'assets/images/provider_profile_english.png',
    'assets/images/provider_profile_english.png',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('provider')) {
      _provider = args['provider'] as Map<String, dynamic>;
    } else {
      // Default provider data if not provided
      _provider = {
        'name': 'Sarah Johnson',
        'rating': 4.8,
        'category_key': 'categories.photography',
        'image': 'assets/images/provider_profile_english.png',
        'color': AppTheme.photographyColor,
        'bio': 'Professional photographer offering event photography services for weddings, parties, and more. Capturing your special moments with a creative touch!',
      };
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _addToCart(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_services[index]['name']} ${AppLocalizations.of(context).translate('service.add_to_cart')}',
        ),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
  
  void _messageProvider() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('provider_profile.message'),
        ),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }
  
  void _saveProvider() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('provider_profile.save'),
        ),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with provider cover image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.festiveGradient,
                ),
                child: Stack(
                  children: [
                    // Profile image
                    Positioned(
                      bottom: -40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              _provider['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Provider info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Column(
                children: [
                  // Provider name
                  Text(
                    _provider['name'],
                    style: isArabic ? AppTheme.headingH1Arabic : AppTheme.headingH1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating and verified badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.warningColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_provider['rating']}',
                        style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: AppTheme.successColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              localizations.translate('provider_profile.verified'),
                              style: (isArabic ? AppTheme.captionArabic : AppTheme.caption).copyWith(
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _provider['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      localizations.translate(_provider['category_key']),
                      style: (isArabic ? AppTheme.body2Arabic : AppTheme.body2).copyWith(
                        color: _provider['color'],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bio
                  Text(
                    _provider['bio'],
                    style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _messageProvider,
                        icon: const Icon(Icons.message),
                        label: Text(
                          localizations.translate('provider_profile.message'),
                          style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.festiveColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _saveProvider,
                        icon: const Icon(Icons.favorite_border),
                        label: Text(
                          localizations.translate('provider_profile.save'),
                          style: (isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText).copyWith(
                            color: AppTheme.festiveColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Tab bar
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppTheme.festiveColor,
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorColor: AppTheme.festiveColor,
                tabs: [
                  Tab(text: localizations.translate('provider_profile.services')),
                  Tab(text: localizations.translate('provider_profile.portfolio')),
                  Tab(text: localizations.translate('provider_profile.reviews')),
                ],
              ),
            ),
            pinned: true,
          ),
          
          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Services tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Service image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              service['image'],
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
                                // Service name
                                Text(
                                  service['name'],
                                  style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
                                ),
                                const SizedBox(height: 8),
                                
                                // Service price
                                Row(
                                  children: [
                                    Text(
                                      '${localizations.translate('service.price')}: ',
                                      style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                                    ),
                                    Text(
                                      '\$${service['price']}',
                                      style: (isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4).copyWith(
                                        color: AppTheme.festiveColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Add to cart button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _addToCart(index),
                                    child: Text(
                                      localizations.translate('service.add_to_cart'),
                                      style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Portfolio tab
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _portfolioImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _portfolioImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
                
                // Reviews tab
                Center(
                  child: Text(
                    localizations.translate('provider_profile.reviews'),
                    style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
