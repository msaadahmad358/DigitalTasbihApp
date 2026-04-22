import 'package:flutter/material.dart';

class AppConstants {
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
  );

  static const primaryColor = Color(0xFF00B4DB);
  static const secondaryColor = Color(0xFF0083B0);

  static const double borderRadiusLarge = 28;
  static const double borderRadiusMedium = 20;
  static const double borderRadiusSmall = 16;

  static const EdgeInsets paddingLarge = EdgeInsets.all(24);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16);
  static const EdgeInsets paddingSmall = EdgeInsets.all(12);
}
