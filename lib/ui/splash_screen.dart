import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travels/ui/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Timer(Duration(seconds: 5), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}

