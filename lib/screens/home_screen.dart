import 'package:crime_alert/screens/crime_map_screen.dart';
import 'package:crime_alert/screens/my_reports_screen.dart';
import 'package:crime_alert/screens/report_crime_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  Future<void> loadUserName() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    setState(() {

      userName = prefs.getString("userName") ?? "";
    });
  }
  @override
  void initState() {
    super.initState();

    loadUserName();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Crime Alert',
              style: TextStyle(color: Color(0xFF1E88E5),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.check_box_outline_blank, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Greeting
            Text(
              'Hello, $userName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome to Crime Alert',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // Report Crime
            _featureCard(
              title: 'Report Crime',
              icon: Icons.shield,
              background: const Color(0xFF1E88E5),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportCrimeScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // View My Reports
            _featureCard(
              title: 'View My Reports',
              icon: Icons.description,
              background: const Color(0xFFE53935),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyReportsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Crime Map
            _featureCard(
              title: 'Crime Map',
              icon: Icons.location_on,
              background: const Color(0xFF1E88E5),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CrimeMapScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: const Color(0xFF1E88E5),
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.map),
      //       label: 'Map',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list_alt),
      //       label: 'Reports',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }

  // Feature Card Widget
  Widget _featureCard({
    required String title,
    required IconData icon,
    required Color background,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: background.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                icon,
                size: 140,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const MainNavigation(),
//   ),
// );