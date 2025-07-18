import 'package:myapp/screens/home.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'screens/landing.dart';
import 'package:myapp/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Finance App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnboardingScreen(),
    );
  }
}
