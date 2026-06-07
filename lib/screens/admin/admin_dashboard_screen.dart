import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'analytics_screen.dart';
import 'manage_reports_screen.dart';
import 'manage_users_screen.dart';
import '../login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int totalUsers = 0;
  int totalReports = 0;
  int pendingReports = 0;
  int resolvedReports = 0;
  int investigatingReports = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final response = await http.get(
        Uri.parse("https://crime-alert.onrender.com/api/admin/dashboard"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          totalUsers = data["totalUsers"] ?? 0;
          totalReports = data["totalReports"] ?? 0;
          pendingReports = data["pendingReports"] ?? 0;
          investigatingReports = data["investigatingReports"] ?? 0;
          resolvedReports = data["resolvedReports"] ?? 0;
        });
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Dashboard Error: $e");
    } finally {
      setState(() {
        isLoading = false;
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
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF1E88E5)),

            onPressed: () {
              showDialog(
                context: context,

                builder:
                    (_) => AlertDialog(
                      title: const Text("Logout"),

                      content: const Text("Are you sure you want to logout?"),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text("Cancel"),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),

                              (route) => false,
                            );
                          },

                          child: const Text("Logout"),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5),
                borderRadius: BorderRadius.circular(24),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Welcome Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Crime Alert Management System",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "System Statistics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              children: [
                statCard(
                  title: "Users",
                  value: "$totalUsers",
                  icon: Icons.people,
                  color: Colors.blue,
                ),

                statCard(
                  title: "Reports",
                  value: "$totalReports",
                  icon: Icons.description,
                  color: Colors.deepPurple,
                ),

                statCard(
                  title: "Pending",
                  value: "$pendingReports",
                  icon: Icons.pending,
                  color: Colors.orange,
                ),

                statCard(
                  title: "Resolved",
                  value: "$resolvedReports",
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            dashboardAction(
              title: "Manage Reports",
              icon: Icons.description,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageReportsScreen(),
                  ),
                );
              },
            ),

            dashboardAction(
              title: "Manage Users",
              icon: Icons.people,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
                );
              },
            ),

            dashboardAction(
              title: "Analytics",
              icon: Icons.bar_chart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),

            child: Icon(icon, color: color),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget dashboardAction({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),

          child: Icon(icon, color: const Color(0xFF1E88E5)),
        ),

        title: Text(title),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: onTap,
      ),
    );
  }
}
