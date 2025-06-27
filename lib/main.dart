import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travels/firebase_options.dart';
import 'package:travels/ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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