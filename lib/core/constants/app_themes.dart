import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryDefault = Color(0xFF24A19C);
  static const Color secondaryColor = Color(0xFF000000);

  static MaterialColor get primarySwatch {
    return MaterialColor(primaryDefault.value, {
      50: primaryDefault.withOpacity(0.05),
      100: primaryDefault.withOpacity(0.1),
      200: primaryDefault.withOpacity(0.2),
      300: primaryDefault.withOpacity(0.3),
      400: primaryDefault.withOpacity(0.4),
      500: primaryDefault,
      600: primaryDefault.withOpacity(0.6),
      700: primaryDefault.withOpacity(0.7),
      800: primaryDefault.withOpacity(0.8),
      900: primaryDefault.withOpacity(0.9),
    });
  }
}

class AppTextStyles {
  // App Logo/Brand text
  static TextStyle appName = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Main titles/headings
  static TextStyle title = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryColor,
  );

  // Subtitle for descriptions
  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey[600],
  );

  // Body text for paragraphs
  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey[700],
  );

  // Button text
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Input labels
  static TextStyle inputLabel = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryColor,
  );

  // Small text (like "or continue with")
  static TextStyle smallText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey[500],
  );

  // Welcome text
  static TextStyle welcomeText = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryColor,
  );
}
