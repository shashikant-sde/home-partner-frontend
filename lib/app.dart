import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/auth/loading_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomePartner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoadingScreen(),
    );
  }
}
