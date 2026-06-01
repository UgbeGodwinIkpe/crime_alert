import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        title: const Text("About App"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 20),

            Image.asset(
              "assets/logo.png",
              height: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "Crime Alert",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Text(
                "Crime Alert is a mobile-based crime reporting system that enables citizens to report criminal activities, track report status, and assist law enforcement agencies with timely information. The platform promotes community participation in crime prevention and public safety.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Key Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            featureTile(Icons.report, "Crime Reporting"),
            featureTile(Icons.location_on, "Crime Mapping"),
            featureTile(Icons.track_changes, "Report Tracking"),
            featureTile(Icons.notifications, "Notifications"),
            featureTile(Icons.admin_panel_settings, "Admin Management"),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Column(
                children: [

                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Developers Team"),
                    subtitle: Text("Cidusface Group"),
                  ),

                  Divider(),

                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text("Company"),
                    subtitle: Text("Cidusface Group"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "© 2026 Crime Alert System",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static Widget featureTile(
    IconData icon,
    String title,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(title),
      ),
    );
  }
}