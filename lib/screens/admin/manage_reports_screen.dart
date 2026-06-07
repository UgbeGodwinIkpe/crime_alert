import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'report_details_screen.dart';

class ManageReportsScreen extends StatefulWidget {
  const ManageReportsScreen({super.key});

  @override
  State<ManageReportsScreen> createState() => _ManageReportsScreenState();
}

class _ManageReportsScreenState extends State<ManageReportsScreen> {
  List reports = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final response = await http.get(
        Uri.parse("https://crime-alert.onrender.com/api/reports/all"),
      );

      if (response.statusCode == 200) {
        setState(() {
          reports = jsonDecode(response.body);

          isLoading = false;
        });
      }
      print(reports);
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "Investigating":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Reports")),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: reports.length,

                itemBuilder: (context, index) {
                  final report = reports[index];

                  return Card(
                    margin: const EdgeInsets.all(10),

                    child: ListTile(
                      title: Text(report["title"] ?? "Crime Report"),

                      subtitle: Text(report["description"] ?? "", maxLines: 2),

                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: statusColor(report["status"]),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          report["status"],

                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => ReportDetailsScreen(report: report),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
