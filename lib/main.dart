import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eventify/firebase_options.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';
import 'package:eventify/providers/auth_provider.dart';
import 'package:eventify/screens/splash_screen.dart';
import 'package:eventify/screens/onboarding_screen.dart';
import 'package:eventify/screens/home_screen.dart';
import 'package:eventify/screens/auth/login_screen.dart';
import 'package:eventify/screens/auth/registration_screen.dart';
import 'package:eventify/screens/auth/phone_verification_screen.dart';
import 'package:eventify/screens/user_profile_screen.dart';
import 'package:eventify/screens/service_provider_profile_screen.dart';
import 'package:eventify/screens/service_listing_screen.dart';
import 'package:eventify/screens/cart_screen.dart';
import 'package:eventify/screens/checkout_screen.dart';
import 'package:eventify/screens/admin_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Load saved language preference
  final prefs = await SharedPreferences.getInstance();
  final String languageCode = prefs.getString('language_code') ?? 'en';
  
  runApp(MyApp(locale: Locale(languageCode)));
}

class MyApp extends StatelessWidget {
  final Locale locale;
  
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppLanguageProvider(locale),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Consumer<AppLanguageProvider>(
        builder: (context, appLanguage, child) {
          return MaterialApp(
            title: 'Eventify',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: AppTheme.festiveColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppTheme.festiveColor,
                primary: AppTheme.festiveColor,
                secondary: AppTheme.celebrationColor,
                tertiary: AppTheme.joyfulColor,
              ),
              fontFamily: appLanguage.locale.languageCode == 'ar' ? 'Tajawal' : 'Poppins',
              textTheme: appLanguage.locale.languageCode == 'ar' 
                  ? AppTheme.arabicTextTheme 
                  : AppTheme.englishTextTheme,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.festiveColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: AppTheme.festiveColor,
                ),
                titleTextStyle: appLanguage.locale.languageCode == 'ar'
                    ? AppTheme.headingH4Arabic.copyWith(color: AppTheme.textPrimary)
                    : AppTheme.headingH4.copyWith(color: AppTheme.textPrimary),
              ),
            ),
            locale: appLanguage.locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.onboarding: (context) => const OnboardingScreen(),
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.registration: (context) => const RegistrationScreen(),
              AppRoutes.phoneVerification: (context) => const PhoneVerificationScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
              AppRoutes.userProfile: (context) => const UserProfileScreen(),
              AppRoutes.serviceProviderProfile: (context) => const ServiceProviderProfileScreen(),
              AppRoutes.serviceListing: (context) => const ServiceListingScreen(),
              AppRoutes.cart: (context) => const CartScreen(),
              AppRoutes.checkout: (context) => const CheckoutScreen(),
              AppRoutes.adminDashboard: (context) => const AdminDashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
