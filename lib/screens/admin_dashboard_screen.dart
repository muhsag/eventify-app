import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  
  final List<Map<String, dynamic>> _dashboardStats = [
    {
      'title_key': 'admin.users',
      'count': 245,
      'icon': Icons.people,
      'color': AppTheme.infoColor,
    },
    {
      'title_key': 'admin.providers',
      'count': 78,
      'icon': Icons.business,
      'color': AppTheme.festiveColor,
    },
    {
      'title_key': 'admin.orders',
      'count': 156,
      'icon': Icons.shopping_bag,
      'color': AppTheme.successColor,
    },
    {
      'title_key': 'admin.payments',
      'count': '\$12,450',
      'icon': Icons.payments,
      'color': AppTheme.warningColor,
    },
  ];
  
  final List<Map<String, dynamic>> _recentOrders = [
    {
      'id': '#ORD-001',
      'user': 'John Smith',
      'provider': 'Emily Warren',
      'service': 'Wedding Photography',
      'amount': 500,
      'status': 'Completed',
      'date': '2025-05-28',
    },
    {
      'id': '#ORD-002',
      'user': 'Sarah Johnson',
      'provider': 'Megan White',
      'service': 'Event Decoration',
      'amount': 300,
      'status': 'In Progress',
      'date': '2025-05-27',
    },
    {
      'id': '#ORD-003',
      'user': 'Michael Brown',
      'provider': 'James Cook',
      'service': 'Catering Service',
      'amount': 450,
      'status': 'Pending',
      'date': '2025-05-26',
    },
  ];
  
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
          localizations.translate('admin.dashboard'),
          style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.festiveGradient,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppTheme.festiveGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Eventify Admin',
                    style: (isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3).copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'admin@eventify.com',
                    style: (isArabic ? AppTheme.body2Arabic : AppTheme.body2).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text(
                localizations.translate('admin.dashboard'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              selected: _selectedIndex == 0,
              onTap: () => _onNavItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                localizations.translate('admin.users'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              selected: _selectedIndex == 1,
              onTap: () => _onNavItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text(
                localizations.translate('admin.providers'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              selected: _selectedIndex == 2,
              onTap: () => _onNavItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text(
                localizations.translate('admin.orders'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              selected: _selectedIndex == 3,
              onTap: () => _onNavItemTapped(3),
            ),
            ListTile(
              leading: const Icon(Icons.payments),
              title: Text(
                localizations.translate('admin.payments'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              selected: _selectedIndex == 4,
              onTap: () => _onNavItemTapped(4),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                localizations.translate('admin.settings'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              selected: _selectedIndex == 5,
              onTap: () => _onNavItemTapped(5),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                localizations.translate('auth.logout'),
                style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard stats
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _dashboardStats.length,
                itemBuilder: (context, index) {
                  final stat = _dashboardStats[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            stat['icon'],
                            color: stat['color'],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${stat['count']}',
                            style: (isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3).copyWith(
                              color: stat['color'],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            localizations.translate(stat['title_key']),
                            style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Recent orders
              Text(
                localizations.translate('admin.recent_orders'),
                style: isArabic ? AppTheme.headingH3Arabic : AppTheme.headingH3,
              ),
              const SizedBox(height: 16),
              
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentOrders.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final order = _recentOrders[index];
                    return ListTile(
                      title: Text(
                        '${order['id']} - ${order['service']}',
                        style: isArabic ? AppTheme.headingH5Arabic : AppTheme.headingH5,
                      ),
                      subtitle: Text(
                        '${order['user']} • ${order['date']}',
                        style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${order['amount']}',
                            style: (isArabic ? AppTheme.body1Arabic : AppTheme.body1).copyWith(
                              color: AppTheme.festiveColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order['status'],
                              style: (isArabic ? AppTheme.captionArabic : AppTheme.caption).copyWith(
                                color: _getStatusColor(order['status']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // View order details
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // View all button
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to orders screen
                  },
                  child: Text(
                    localizations.translate('general.view_all'),
                    style: (isArabic ? AppTheme.body1Arabic : AppTheme.body1).copyWith(
                      color: AppTheme.festiveColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppTheme.successColor;
      case 'In Progress':
        return AppTheme.infoColor;
      case 'Pending':
        return AppTheme.warningColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}
