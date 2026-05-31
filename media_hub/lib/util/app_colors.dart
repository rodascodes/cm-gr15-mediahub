import 'package:flutter/material.dart';

// Class to store the colors to be used. Makes it simpler to change colors long term.
class AppColors {
  static const Color primary = Color.fromARGB(255, 119, 0, 255); 
  static const Color hintText = Color(0xFF9E9E9E);

  // --- LIGHT THEME COLORS ---
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Color(0xFFF5F5F5); 

  // --- DARK THEME COLORS ---
  static const Color darkBackground = Color.fromARGB(255, 20, 20, 20);
  static const Color darkSurface = Color.fromARGB(255, 40, 40, 40); 

  // --- PROFILE SCREEN ---
  static const Color profileHeaderG1 = Color.fromARGB(255, 123, 44, 191);
  static const Color profileHeaderG2 = Color.fromARGB(255, 247, 37, 133);
}