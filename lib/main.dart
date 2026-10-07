import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const PalfeedCloneApp());
}

class PalfeedCloneApp extends StatelessWidget {
  const PalfeedCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palfeed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1877F2),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}