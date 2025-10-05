// Main entry point for "Memes by MG" app
// Similar to App.js in React - this is our root component

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/meme_list_screen.dart';

void main() {
  runApp(const MemesByMGApp());
}

class MemesByMGApp extends StatelessWidget {
  const MemesByMGApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is like React Router + Theme Provider combined
    return MaterialApp(
      title: 'Memes by MG',
      debugShowCheckedModeBanner: false, // Remove debug banner
      
      // Theme configuration - like CSS in React
      theme: ThemeData(
        // Color scheme - like CSS custom properties
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Beautiful indigo
          brightness: Brightness.light,
        ),
        
        // Typography - like font-family in CSS
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
          ),
        ),
        
        // App bar theme - like header styling
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        
        // Card theme - for meme cards
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // Floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 6,
        ),
        
        // Use Material 3 design
        useMaterial3: true,
      ),
      
        // Dark theme for night mode
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Beautiful indigo
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      // Home screen - like default route in React Router
      home: const MemeListScreen(),
    );
  }
}