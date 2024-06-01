import 'package:flutter/material.dart';
import 'package:prodigit_test/screens/home_page.dart';
import 'package:prodigit_test/utils/colors.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProDigit Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brandColor),
        useMaterial3: true,
      ),
      home:   const HomePage(),
    );
  }
}
