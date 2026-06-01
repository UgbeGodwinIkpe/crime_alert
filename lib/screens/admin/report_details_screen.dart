import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportDetailsScreen extends StatefulWidget {

  final Map report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailsScreen> createState() =>_ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {

  late String selectedStatus;
  Color getStatusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "Investigating":
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  bool updating = false;

  @override
  void initState() {
    super.initState();

    selectedStatus =
        widget.report["status"];
  }

  Future<void> updateStatus() async {

    setState(() {
      updating = true;
    });

    try {

      final response = await http.put(

        Uri.parse(
          "http://localhost:5000/api/reports/update-status/${widget.report["_id"]}",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "status": selectedStatus,
        }),
      );

      if (response.statusCode == 200) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text("Status Updated"),
          ),
        );
      }

    } catch (e) {

      print(e);
    }

    setState(() {
      updating = false;
    });
  }

 Widget _modernCard({
      required String title,
      required IconData icon,
      required String content,
    }) {

      return Container(

        margin:
            const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.05,
              ),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Icon(
                  icon,
                  color:
                      const Color(0xFF1E88E5),
                ),

                const SizedBox(width: 10),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              content,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

  @override
  Widget build(BuildContext context) {

    final report = widget.report;
    final latitude = (report["location"]?["latitude"] ?? 0).toDouble();

    final longitude = (report["location"]?["longitude"] ?? 0).toDouble();    

    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Crime Report",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
          child: Column(
            children: [

              // HERO IMAGE
              Container(
                margin: const EdgeInsets.all(16),

                height: 250,

                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: report["image"] != null
                      ? DecorationImage(
                          image: NetworkImage(
                            report["image"],
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.grey.shade200,
                ),

                child: report["image"] == null
                    ? const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                        ),
                      )
                    : null,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // STATUS CHIP
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: getStatusColor(
                          report["status"],
                        ),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),

                      child: Text(
                        report["status"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      report["title"] ?? "",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _modernCard(
                        title: "Report Information",
                        icon: Icons.info,

                        content:
                            "Report ID: ${report["_id"]}\n\nCreated: ${report["createdAt"]}",
                      ),
                    const SizedBox(height: 20),

                    _modernCard(
                      title: "Description",
                      icon: Icons.description,
                      content:
                          report["description"] ?? "",
                    ),

                    _modernCard(
                      title:
                          "Reporter Information",
                      icon: Icons.person,
                      content:
                          "${report["user"]?["name"] ?? "Unknown"}\n${report["user"]?["email"] ?? ""} \n${report["user"]?["phone"] ?? ""}",
                    ),

                    _modernCard(
                      title:
                          "Location Information",
                      icon: Icons.location_on,
                      content:
                          "${report["location"]?["address"] ?? "No Address"}\n\nNearest Station:\n${report["nearPoliceStation"] ?? "Not Specified"}",
                    ),
                    

                    _modernCard(
                      title: "Coordinates",
                      icon: Icons.map,
                      content:
                          "Latitude: ${report["location"]?["latitude"] ?? ""}\nLongitude: ${report["location"]?["longitude"] ?? ""}",
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.map,
                                color: Color(0xFF1E88E5),
                              ),

                              SizedBox(width: 10),

                              Text(
                                "Crime Location",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(16),

                            child: SizedBox(
                              height: 220,

                              child: GoogleMap(

                                initialCameraPosition:
                                    CameraPosition(
                                  target: LatLng(
                                    latitude,
                                    longitude,
                                  ),
                                  zoom: 15,
                                ),

                                markers: {
                                  Marker(
                                    markerId:
                                        const MarkerId(
                                      "crime",
                                    ),
                                    position: LatLng(
                                      latitude,
                                      longitude,
                                    ),
                                  ),
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Update Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                        border: Border.all(
                          color:
                              Colors.grey.shade300,
                        ),
                      ),

                      child:
                          DropdownButtonHideUnderline(
                        child:
                            DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,

                          items: const [

                            DropdownMenuItem(
                              value: "Pending",
                              child:
                                  Text("Pending"),
                            ),

                            DropdownMenuItem(
                              value:
                                  "Investigating",
                              child: Text(
                                "Investigating",
                              ),
                            ),

                            DropdownMenuItem(
                              value:
                                  "Resolved",
                              child:
                                  Text("Resolved"),
                            ),

                            DropdownMenuItem(
                              value:
                                  "Rejected",
                              child:
                                  Text("Rejected"),
                            ),
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedStatus =
                                  value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF1E88E5,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(16),
                          ),
                        ),

                        onPressed: updating
                            ? null
                            : updateStatus,

                        child: updating

                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                  strokeWidth:
                                      2,
                                ),
                              )

                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  color:
                                      Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}