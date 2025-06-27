import 'package:flutter/material.dart';
import 'package:travels/ui/splash_screen.dart';

void main() {
  runApp(const MyTravelsApp());
}

class MyTravelsApp extends StatelessWidget {
  const MyTravelsApp({super.key});

  final _appName = "Minhas viagens";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0066cc)),
      ),
      home: const SplashScreen(),
    );
  }
}