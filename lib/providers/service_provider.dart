import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eventify/utils/app_theme.dart';
import 'package:eventify/utils/app_routes.dart';
import 'package:eventify/utils/localization.dart';
import 'package:eventify/providers/app_language_provider.dart';

class ServiceProviderData extends ChangeNotifier {
  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'Emily Warren',
      'rating': 4.9,
      'category_key': 'categories.photography',
      'image': 'assets/images/provider_profile_english.png',
      'color': AppTheme.photographyColor,
      'bio': 'Professional photographer offering event photography services for weddings, parties, and more. Capturing your special moments with a creative touch!',
      'services': [
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
      ],
    },
    {
      'id': '2',
      'name': 'Megan White',
      'rating': 4.7,
      'category_key': 'categories.decoration',
      'image': 'assets/images/provider_profile_english.png',
      'color': AppTheme.decorationColor,
      'bio': 'Creative decorator specializing in event decoration for all occasions. Making your events beautiful and memorable!',
      'services': [
        {
          'name': 'Wedding Decoration',
          'price': 600,
          'image': 'assets/images/provider_profile_english.png',
        },
        {
          'name': 'Birthday Decoration',
          'price': 300,
          'image': 'assets/images/provider_profile_english.png',
        },
      ],
    },
    {
      'id': '3',
      'name': 'James Cook',
      'rating': 4.8,
      'category_key': 'categories.catering',
      'image': 'assets/images/provider_profile_english.png',
      'color': AppTheme.cateringColor,
      'bio': 'Professional catering service for all types of events. Delicious food and excellent service guaranteed!',
      'services': [
        {
          'name': 'Wedding Catering',
          'price': 800,
          'image': 'assets/images/provider_profile_english.png',
        },
        {
          'name': 'Corporate Catering',
          'price': 500,
          'image': 'assets/images/provider_profile_english.png',
        },
      ],
    },
  ];
  
  List<Map<String, dynamic>> get providers => _providers;
  
  Map<String, dynamic>? getProviderById(String id) {
    try {
      return _providers.firstWhere((provider) => provider['id'] == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Map<String, dynamic>> getProvidersByCategory(String categoryKey) {
    return _providers.where((provider) => provider['category_key'] == categoryKey).toList();
  }
}
