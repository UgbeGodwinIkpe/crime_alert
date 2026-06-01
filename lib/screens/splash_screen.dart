import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Login after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Logo
            Image.asset(
              'assets/logo.png',
              height: 220,
            ),

            // const SizedBox(height: 16),

            // App Name
            // RichText(
            //   text: const TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Crime',
            //         style: TextStyle(
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFF1E88E5),
            //         ),
            //       ),
            //       TextSpan(
            //         text: 'Alert',
            //         style: TextStyle(
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFFE53935),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            const Spacer(flex: 3),

            // Loading text
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
