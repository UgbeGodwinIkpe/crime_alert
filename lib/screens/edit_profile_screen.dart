import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class EditProfileScreen extends StatefulWidget {

  final String currentName;
  final String currentEmail;
  final String currentPhone;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.currentName;
    emailController.text = widget.currentEmail;
    phoneController.text = widget.currentPhone;
  }

  Future<void> updateProfile() async {

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
          "https://crime-alert.onrender.com/api/users/update/$userId",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
        }),
      );

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text(
              "Profile updated successfully",
            ),
          ),
        );

        Navigator.pop(context, true);
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
        title: const Text("Edit Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: "Full Name",

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,

              decoration: InputDecoration(
                labelText: "Email",

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: phoneController,

              decoration: InputDecoration(
                labelText: "Phone Number",

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
                    isLoading ? null : updateProfile,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),

                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Save Changes",
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