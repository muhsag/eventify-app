import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/auth_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = appLanguage.locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('profile.title'),
          style: isArabic ? AppTheme.headingH4Arabic : AppTheme.headingH4,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.translate('profile.logout_confirmation_title')),
                  content: Text(localizations.translate('profile.logout_confirmation_message')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(localizations.translate('general.cancel')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        localizations.translate('profile.logout'),
                        style: const TextStyle(color: AppTheme.errorColor),
                      ),
                    ),
                  ],
                ),
              );
              
              if (shouldLogout == true) {
                await authProvider.logout();
                if (!mounted) return;
                
                // Navigate to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      
                      // Profile avatar
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.festiveColor,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // User type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: authProvider.userType == 'provider'
                              ? AppTheme.celebrationColor.withOpacity(0.1)
                              : AppTheme.joyfulColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          authProvider.userType == 'provider'
                              ? localizations.translate('profile.service_provider')
                              : localizations.translate('profile.regular_user'),
                          style: TextStyle(
                            color: authProvider.userType == 'provider'
                                ? AppTheme.celebrationColor
                                : AppTheme.joyfulColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Phone number
                      ListTile(
                        leading: const Icon(Icons.phone, color: AppTheme.festiveColor),
                        title: Text(
                          localizations.translate('auth.phone_number'),
                          style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                        ),
                        subtitle: Text(
                          authProvider.phoneNumber,
                          style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                        ),
                      ),
                      
                      const Divider(),
                      
                      // Language settings
                      ListTile(
                        leading: const Icon(Icons.language, color: AppTheme.festiveColor),
                        title: Text(
                          localizations.translate('profile.language'),
                          style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                        ),
                        subtitle: Text(
                          isArabic
                              ? localizations.translate('profile.language_arabic')
                              : localizations.translate('profile.language_english'),
                          style: isArabic ? AppTheme.body1Arabic : AppTheme.body1,
                        ),
                        trailing: Switch(
                          value: isArabic,
                          activeColor: AppTheme.festiveColor,
                          onChanged: (value) {
                            appLanguage.changeLanguage(value ? const Locale('ar') : const Locale('en'));
                          },
                        ),
                      ),
                      
                      const Divider(),
                      
                      // App version
                      ListTile(
                        leading: const Icon(Icons.info_outline, color: AppTheme.festiveColor),
                        title: Text(
                          localizations.translate('profile.app_version'),
                          style: isArabic ? AppTheme.body2Arabic : AppTheme.body2,
                        ),
                        subtitle: const Text('1.0.0'),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Show confirmation dialog
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(localizations.translate('profile.logout_confirmation_title')),
                                content: Text(localizations.translate('profile.logout_confirmation_message')),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text(localizations.translate('general.cancel')),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text(
                                      localizations.translate('profile.logout'),
                                      style: const TextStyle(color: AppTheme.errorColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            
                            if (shouldLogout == true) {
                              await authProvider.logout();
                              if (!mounted) return;
                              
                              // Navigate to login screen
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              );
                            }
                          },
                          icon: const Icon(Icons.logout),
                          label: Text(
                            localizations.translate('profile.logout'),
                            style: isArabic ? AppTheme.buttonTextArabic : AppTheme.buttonText,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: AppTheme.errorColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
