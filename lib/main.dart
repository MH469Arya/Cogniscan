import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CogniscanApp(),
    ),
  );
}

class CogniscanApp extends StatelessWidget {
  const CogniscanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cogniscan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingScreen(),
    );
  }
}
