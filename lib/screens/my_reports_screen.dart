import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  List reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final data = await ApiService.getMyReports();
      setState(() {
        reports = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔹 STATUS COLORS
  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return const Color(0xFFFFF3CD);
      case "Investigating":
        return const Color(0xFFE3F2FD);
      case "Resolved":
        return const Color(0xFFE8F5E9);
      default:
        return Colors.grey.shade200;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case "Pending":
        return const Color(0xFF856404);
      case "Investigating":
        return const Color(0xFF1565C0);
      case "Resolved":
        return const Color(0xFF2E7D32);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Reports',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? const Center(child: Text("No reports yet"))
              : Column(
                  children: [
                    // 🔥 REPORT LIST
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: reports.map((report) {
                          return Column(
                            children: [
                              _ReportItem(
                                
                                title: report["title"] ?? "No Title",
                                address: report["location"]?["address"] ??
                                    "Unknown",
                                status: report["status"] ?? "Pending",
                                statusColor:
                                    getStatusColor(report["status"]),
                                statusTextColor:
                                    getStatusTextColor(report["status"]),
                                iconColor: Colors.blue,
                                date: report["createdAt"] != null
                                    ? report["createdAt"]
                                        .substring(0, 10)
                                    : null,
                                onDelete: () async {
                                  bool success = await ApiService.deleteReport(report["_id"]);

                                  if (success) {
                                    _fetchReports(); // refresh list
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Report withdrawn")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Failed to withdraw")),
                                    );
                                  }
                                },
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    // Map preview
                    Expanded(
                      child: Container(
                        margin:
                            const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image:
                                AssetImage('assets/map_preview.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _ReportItem extends StatelessWidget {
  final String title;
  final String address;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final Color iconColor;
  final String? date;
  final VoidCallback? onDelete;

  const _ReportItem({
    required this.title,
    required this.address,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.iconColor,
    this.date,
    this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(Icons.report, color: iconColor),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusTextColor,
                  ),
                ),
              ),
              if (date != null) ...[
                const SizedBox(height: 6),
                Text(
                  date!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
              if (onDelete != null) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: const Text(
                    "Tap here to\nwithdraw",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}