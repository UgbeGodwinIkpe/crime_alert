import 'dart:async';
import 'package:crime_alert/screens/admin/admin_dashboard_screen.dart';
import 'package:crime_alert/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _splashNavigation();
  }

  Future<void> _splashNavigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    final role = prefs.getString("role");

    // Navigate to Login after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        // runApp(HomeApp());
        if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
        }
      } else {
        // runApp(LoginApp());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
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
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Logo
            Image.asset('assets/logo.png', height: 220),

            const Spacer(flex: 3),

            // Loading text
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                'Loading...',
                style: TextStyle(color: Colors.grey, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
