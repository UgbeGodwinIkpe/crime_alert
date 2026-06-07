import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  // bool darkModeEnabled = false;
  bool locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Color(0xFF1E88E5)),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // GENERAL SETTINGS
            _sectionTitle("General"),

            _switchTile(
              title: "Notifications",
              subtitle: "Enable app notifications",

              value: notificationsEnabled,

              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },

              icon: Icons.notifications,
            ),

            _switchTile(
              title: "Dark Mode",
              subtitle: "Enable dark theme",

              value: themeProvider.isDarkMode,

              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },

              icon: Icons.dark_mode,
            ),

            _switchTile(
              title: "Location Services",
              subtitle: "Allow location access",

              value: locationEnabled,

              onChanged: (value) {
                setState(() {
                  locationEnabled = value;
                });
              },

              icon: Icons.location_on,
            ),

            const SizedBox(height: 25),

            // SECURITY SECTION
            _sectionTitle("Security & Privacy"),

            _settingsTile(
              icon: Icons.lock,
              title: "Privacy Policy",
              subtitle: "Read privacy policy",
              onTap: () {},
            ),

            _settingsTile(
              icon: Icons.security,
              title: "Security",
              subtitle: "Manage account security",
              onTap: () {},
            ),

            const SizedBox(height: 25),

            // APP SECTION
            _sectionTitle("Application"),

            _settingsTile(
              icon: Icons.language,
              title: "Language",
              subtitle: "English",
              onTap: () {},
            ),

            _settingsTile(
              icon: Icons.info_outline,
              title: "About App",
              subtitle: "Crime Alert v1.0.0",
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Settings saved successfully"),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  padding: const EdgeInsets.symmetric(vertical: 15),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  "Save Settings",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // SWITCH TILE
  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: SwitchListTile(
        value: value,
        onChanged: onChanged,

        secondary: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),

          child: Icon(icon, color: Colors.blue),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        subtitle: Text(subtitle),
      ),
    );
  }

  // SETTINGS TILE
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),

          child: Icon(icon, color: Colors.blue),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        subtitle: Text(subtitle),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
