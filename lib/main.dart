import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(

      create: (_) => ThemeProvider(),

      child: const CrimeAlertApp(),
    ),);
}

class CrimeAlertApp extends StatelessWidget {
  const CrimeAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrimeAlert',
      themeMode:
          themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      // theme: ThemeData(
      //   primaryColor: const Color(0xFF1E88E5),
      //   scaffoldBackgroundColor: Colors.white,
      //   fontFamily: 'Roboto',
      // ),
      home: const SplashScreen(),
    );
  }
}
