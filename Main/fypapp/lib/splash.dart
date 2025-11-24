import 'package:flutter/material.dart';
import 'dart:async';
import './signup.dart';

class Splash extends StatefulWidget { // Splash should be a StatefulWidget
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // Delay for 5 seconds and then navigate to the next screen
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SignupPage()), // Navigate to your LoginPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13A795),
      body: Stack(
        children: [
          // Logo in the center
          Positioned(
            top: 150, // Adjust this value to move the logo up or down
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'lib/images/logo.png', // Path to your logo image
                width: 350, // Adjust size as needed
                height: 350,
              ),
            ),
          ),
          // Bottom image with opacity
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.3, // Adjust opacity here (0.0 to 1.0)
              child: Image.asset(
                'lib/images/logo.png', // Correct path to the bottom image
                fit: BoxFit.cover,
                height: 300, // Adjust the height as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
