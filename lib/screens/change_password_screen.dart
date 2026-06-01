import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final TextEditingController oldPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> changePassword() async {

    if (newPasswordController.text !=
        confirmPasswordController.text) {

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

      SharedPreferences prefs =
          await SharedPreferences.getInstance();

      String? userId =
          prefs.getString("userId");

      final response = await http.put(

        Uri.parse(
          "http://localhost:5000/api/users/change-password/$userId",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "oldPassword":
              oldPasswordController.text,

          "newPassword":
              newPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
              data["message"],
            ),
          ),
        );

        Navigator.pop(context);
      }

      else {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
              data["message"],
            ),
          ),
        );
      }

    } catch (e) {

      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: oldPasswordController,
              obscureText: true,

              decoration: InputDecoration(
                labelText: "Old Password",

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: newPasswordController,
              obscureText: true,

              decoration: InputDecoration(
                labelText: "New Password",

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  confirmPasswordController,

              obscureText: true,

              decoration: InputDecoration(
                labelText: "Confirm Password",

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed:
                    isLoading ? null : changePassword,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),

                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Update Password",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}