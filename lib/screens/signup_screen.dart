import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isConfirmPasswordVisible = false;

  bool isLoading = false;
  bool isPasswordVisible = false;

  Future<void> registerUser() async {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "All fields are required",
          ),
        ),
      );

      return;
    }
    if (passwordController.text != confirmPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response = await http.post(

        Uri.parse(
          "http://localhost:5000/api/auth/register",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "name": nameController.text,
          "email": emailController.text,
          "role":"user",
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 ||
          response.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
              data["message"] ??
                  "Registration successful",
            ),
          ),
        );

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
        );
      }

      else {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
              data["message"] ??
                  "Registration failed",
            ),
          ),
        );
      }

    } catch (e) {

      print(e);

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Something went wrong",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F8FC),

      body: Stack(
        children: [
          // SafeArea(
        
          SingleChildScrollView(
        
            padding: const EdgeInsets.all(24),
        
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
        
              children: [
        
                const SizedBox(height: 40),
        
                const Center(
                  child: Icon(
                    Icons.shield,
                    size: 90,
                    color: Colors.blue,
                  ),
                ),
        
                const SizedBox(height: 20),
        
                const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
        
                const SizedBox(height: 8),
        
                const Center(
                  child: Text(
                    "Join Crime Alert today",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
        
                const SizedBox(height: 40),
        
                // NAME
                TextField(
                  controller: nameController,
        
                  decoration: InputDecoration(
        
                    labelText: "Full Name",
        
                    prefixIcon:
                        const Icon(Icons.person),
        
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
        
                const SizedBox(height: 20),
        
                // EMAIL
                TextField(
                  controller: emailController,
        
                  decoration: InputDecoration(
        
                    labelText: "Email",
        
                    prefixIcon:
                        const Icon(Icons.email),
        
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
        
                const SizedBox(height: 20),
        
                TextField(
                  controller: passwordController,
        
                  obscureText: !isPasswordVisible,
        
                  decoration: InputDecoration(
                    labelText: "Password",
        
                    prefixIcon: const Icon(Icons.lock),
        
                    suffixIcon: IconButton(
        
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
        
                      onPressed: () {
        
                        setState(() {
        
                          isPasswordVisible =
                              !isPasswordVisible;
                        });
                      },
                    ),
        
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
        
                  obscureText: !isConfirmPasswordVisible,
        
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
        
                    prefixIcon: const Icon(Icons.lock_outline),
        
                    suffixIcon: IconButton(
        
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
        
                      onPressed: () {
        
                        setState(() {
        
                          isConfirmPasswordVisible =
                              !isConfirmPasswordVisible;
                        });
                      },
                    ),
        
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                // REGISTER BUTTON
                SizedBox(
                  width: double.infinity,
        
                  child: ElevatedButton(
        
                    onPressed:
                        isLoading
                            ? null
                            : registerUser,
        
                    style:
                        ElevatedButton.styleFrom(
        
                      backgroundColor:
                          Colors.blue,
        
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
        
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
        
                    child: isLoading
        
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
        
                        : const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
        
                const SizedBox(height: 25),
        
                // LOGIN
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
        
                  children: [
        
                    const Text(
                      "Already have an account?",
                    ),
        
                    TextButton(
        
                      onPressed: () {
        
                        Navigator.pushReplacement(
        
                          context,
        
                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginScreen(),
                          ),
                        );
                      },
        
                      child: const Text(
                        "Login",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        // ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),

            child: const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      CircularProgressIndicator(),

                      SizedBox(height: 16),

                      Text(
                        "Please wait...",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}