import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() =>_AnalyticsScreenState();
}
class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List statusStats = [];
  List locationStats = [];
  List monthlyStats = [];

  bool isLoading = true;

  Future<void> loadAnalytics() async {

    try {

      final response = await http.get(
        Uri.parse(
          "http://localhost:5000/api/admin/analytics",
        ),
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        setState(() {

          statusStats =
              data["statusStats"];

          locationStats =
              data["locationStats"];

          monthlyStats =
              data["monthlyStats"];

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

  @override
  void initState() {
    super.initState();
    loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F8FC),

      appBar: AppBar(
        title:
            const Text("Analytics"),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Reports by Status",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    height: 250,
                    child:
                        buildStatusChart(),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Reports by Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  buildLocationList(),

                  const SizedBox(height: 30),

                  const Text(
                    "Reports by Month",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  buildMonthlyList(),
                ],
              ),
            ),
    );
  }

  Widget buildStatusChart() {

    return PieChart(

      PieChartData(

        sections:
            statusStats.map((item) {

          return PieChartSectionData(

            value:
                item["count"]
                    .toDouble(),

            title:
                item["_id"],

            radius: 90,
          );

        }).toList(),
      ),
    );
  }

  Widget buildLocationList() {

    return Column(

      children:

          locationStats.map((location) {

        return ListTile(

          leading:
              const Icon(Icons.location_on),

          title: Text(
            location["_id"] ??
                "Unknown Location",
          ),

          trailing: Text(
            location["count"]
                .toString(),
          ),
        );

      }).toList(),
    );
  }

  Widget buildMonthlyList() {
    return Column(

      children:

          monthlyStats.map((month) {

        return ListTile(

          leading:
              const Icon(Icons.calendar_month),

          title: Text(

            "${month["_id"]["month"]}/${month["_id"]["year"]}",
          ),

          trailing: Text(
            month["count"]
                .toString(),
          ),
        );

      }).toList(),
    );
  }
}