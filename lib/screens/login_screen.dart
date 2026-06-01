import 'package:crime_alert/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 200),
              const SizedBox(height: 5),

              _inputField("Email", Icons.person, controller: emailController),
              const SizedBox(height: 16),

              _inputField("Password", Icons.lock,
                  controller: passwordController, obscure: true,
                  obscureText: !isPasswordVisible,
                  ),

              const SizedBox(height: 16),

              // 🔐 LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 2, 112),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleLogin,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login",
                          style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 16),

              // REGISTER BUTTON (leave for now)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 112, 19, 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // we’ll connect this later
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text("Register",
                      style: TextStyle(color: Colors.white)),
                ),
              ),

              // TextButton(
              //   onPressed: () {},
              //   child: const Text(
              //     "Report Anonymously",
              //     style: TextStyle(color: Color(0xFFE53935)),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔐 LOGIN FUNCTION
  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.containsKey("token")) {
        await AuthService.saveToken(response["token"]);
        SharedPreferences prefs =await SharedPreferences.getInstance();

        prefs.setString(
          "userId",
          response["user"]["id"],
        );
        prefs.setString(
          "userName",
          response["user"]["name"],
        );
        prefs.setString(
          "role",
          response["user"]["role"],
        );
        String role = response["user"]["role"];
        // ✅ Navigate to main app
        if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AdminDashboardScreen(),
            ),
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainNavigation(),
            ),
          );
        }
      } else {
        _showMessage(response["message"] ?? "Login failed");
      }
    } catch (e) {
      print(e);
      _showMessage("Something went wrong");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _inputField(String label, IconData icon,
      {bool obscure = false, obscureText=false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon,
            color: const Color.fromARGB(255, 18, 2, 112)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}