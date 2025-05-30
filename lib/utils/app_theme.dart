import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color festiveColor = Color(0xFF8E44AD); // Purple
  static const Color celebrationColor = Color(0xFFE91E63); // Pink
  static const Color joyfulColor = Color(0xFF00BCD4); // Teal
  
  // Category Colors
  static const Color photographyColor = Color(0xFF3498DB); // Blue
  static const Color decorationColor = Color(0xFFE67E22); // Orange
  static const Color cateringColor = Color(0xFF27AE60); // Green
  static const Color drinksColor = Color(0xFFF1C40F); // Yellow
  static const Color sweetsColor = Color(0xFFE84393); // Pink
  static const Color planningColor = Color(0xFF9B59B6); // Purple
  
  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  
  // UI Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color shadowColor = Color(0x1A000000);
  
  // Feedback Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  
  // Gradients
  static const LinearGradient festiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [festiveColor, celebrationColor],
  );
  
  static const LinearGradient joyfulGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [joyfulColor, festiveColor],
  );
  
  // English Typography using Google Fonts
  static TextStyle get headingH1 => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH4 => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH5 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get body1 => GoogleFonts.poppins(
    fontSize: 16,
    color: textPrimary,
  );
  
  static TextStyle get body2 => GoogleFonts.poppins(
    fontSize: 14,
    color: textSecondary,
  );
  
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    color: textLight,
  );
  
  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  // Arabic Typography using Google Fonts
  static TextStyle get headingH1Arabic => GoogleFonts.tajawal(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH2Arabic => GoogleFonts.tajawal(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH3Arabic => GoogleFonts.tajawal(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH4Arabic => GoogleFonts.tajawal(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get headingH5Arabic => GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static TextStyle get body1Arabic => GoogleFonts.tajawal(
    fontSize: 16,
    color: textPrimary,
  );
  
  static TextStyle get body2Arabic => GoogleFonts.tajawal(
    fontSize: 14,
    color: textSecondary,
  );
  
  static TextStyle get captionArabic => GoogleFonts.tajawal(
    fontSize: 12,
    color: textLight,
  );
  
  static TextStyle get buttonTextArabic => GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  // Text Themes
  static TextTheme get englishTextTheme => TextTheme(
    displayLarge: headingH1,
    displayMedium: headingH2,
    displaySmall: headingH3,
    headlineMedium: headingH4,
    headlineSmall: headingH5,
    bodyLarge: body1,
    bodyMedium: body2,
    bodySmall: caption,
    labelLarge: buttonText,
  );
  
  static TextTheme get arabicTextTheme => TextTheme(
    displayLarge: headingH1Arabic,
    displayMedium: headingH2Arabic,
    displaySmall: headingH3Arabic,
    headlineMedium: headingH4Arabic,
    headlineSmall: headingH5Arabic,
    bodyLarge: body1Arabic,
    bodyMedium: body2Arabic,
    bodySmall: captionArabic,
    labelLarge: buttonTextArabic,
  );
}
