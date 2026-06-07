import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'about_app_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'help_support_screen.dart';
import 'change_password_screen.dart';
import 'settings_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String phone = "";
  String location = "Fetching location...";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchProfile();
    _getLocation();
  }

  Future<void> _fetchProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userId = prefs.getString("userId");

      if (userId == null) {
        return;
      }

      final response = await http.get(
        Uri.parse("https://crime-alert.onrender.com/api/users/profile/$userId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        setState(() {
          name = data["name"] ?? "";
          email = data["email"] ?? "";
          phone = data["phone"] ?? "";

          isLoading = false;
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          location = "Location disabled";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          location = "Permission denied";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      setState(() {
        location = "${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
      });
    } catch (e) {
      setState(() {
        location = "Unknown location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF1E88E5)),
        ),
        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              child: const Icon(Icons.settings, color: Color(0xFF1E88E5)),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // PROFILE CARD
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  // PROFILE IMAGE
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Color(0xFF1E88E5),

                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: Container(
                          padding: const EdgeInsets.all(6),

                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // USER NAME
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // EMAIL
                  Text(email, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),

                  // EXTRA DETAILS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoItem(Icons.phone, phone),

                      _infoItem(Icons.location_on, location),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // PROFILE OPTIONS
            _profileOption(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () async {
                final result = await Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder:
                        (_) => EditProfileScreen(
                          currentName: name,
                          currentEmail: email,
                          currentPhone: phone,
                        ),
                  ),
                );

                if (result == true) {
                  _fetchProfile();
                }
              },
            ),

            _profileOption(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),

            // _profileOption(
            //   icon: Icons.notifications,
            //   title: 'Notifications',
            //   onTap: () {},
            // ),
            _profileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                );
              },
            ),

            _profileOption(
              icon: Icons.info_outline,
              title: 'About App',
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => const AboutAppScreen(),
                //   ),
                // );
              },
            ),

            _profileOption(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: Colors.red,

              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // PROFILE OPTION TILE
  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF1E88E5),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),

          child: Icon(icon, color: iconColor),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: onTap,
      ),
    );
  }

  // USER INFO WIDGET
  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),

        const SizedBox(width: 6),

        Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
