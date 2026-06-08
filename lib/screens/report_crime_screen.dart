import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ReportCrimeScreen extends StatefulWidget {
  const ReportCrimeScreen({super.key});

  @override
  State<ReportCrimeScreen> createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  String? selectedCrime;
  String? selectedPoliceStation;
  bool anonymous = false;
  File? _selectedImage;
  String currentAddress = "Fetching location...";
  double? latitude;
  double? longitude;
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // PICK IMAGE
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Future<void> _pickImage() async {
  //   try {
  //     final pickedFile = await _picker.pickMedia();
  //     if (!mounted) return;
  //     if (pickedFile != null) {
  //       setState(() {
  //         _selectedImage = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Picker error: $e");
  //   }
  // }

  // 🔹 SUBMIT REPORT
  Future<void> _submitReport() async {
    if (selectedCrime == null || descriptionController.text.isEmpty) {
      _showMessage("Please fill all required fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool success = await ApiService.createReport(
        title: selectedCrime!,
        description: descriptionController.text.trim(),
        nearPoliceStation: selectedPoliceStation ?? "Unknown",
        address: currentAddress,
        latitude: latitude?.toString() ?? "0.0",
        longitude: longitude?.toString() ?? "0.0",
        image: _selectedImage,
      );

      if (success) {
        _showMessage("Report submitted successfully");

        // Reset form
        setState(() {
          selectedCrime = null;
          selectedPoliceStation = null;
          descriptionController.clear();
          _selectedImage = null;
        });
      } else {
        _showMessage("Failed to submit report");
      }
    } catch (e) {
      _showMessage("Error submitting report ");
    }

    setState(() {
      isLoading = false;
    });
  }

  // 🔹 SNACKBAR
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  final List<String> crimeTypes = [
    'Robbery',
    'Kidnapping',
    'Assault',
    'Fraud',
    'Murder',
    'Rape',
    'Burglary',
    'Other',
  ];

  final List<String> policeStations = [
    'Apo Police Station',
    'Asokoro Police Station',
    'Bwari Police Station',
    'Byazhin Police Station',
    'Dakibiyu Police Station',
    'Dawaki Police Station',
    'Durumi Police Station',
    'Galadimawa Police Station',
    'Garki Police Station',
    'Garki Area 10 Police Station',
    'Gudu Police Station',
    'Guzape Police Station',
    'Gwagwalada Police Station',
    'Gwarinpa Police Station',
    'Jabi Police Station',
    'Jahi Police Station',
    'Kado Police Station',
    'Karu Police Station',
    'Karmo Police Station',
    'Katampe Police Station',
    'Kubwa Police Station',
    'Kuje Police Station',
    'Kurudu Police Station',
    'Life Camp Police Station',
    'Lugbe Police Station',
    'Mabushi Police Station',
    'Maitama Police Station',
    'Mpape Police Station',
    'Nyanya Police Station',
    'Orozo Police Station',
    'Utako Police Station',
    'Wuye Police Station',
    'Wuse Police Station',
    'Wuse Zone 3 Police Station',
    'Zuba Police Station',
    'Zone 7 Police Headquarters',
    'FCT Police Command Headquarters',
    'Jikwoyi Police Station',
  ];

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage("Please enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          _showMessage("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          "Location permission permanently denied. Enable it in Settings.",
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude!,
        longitude!,
      );

      Placemark place = placemarks[0];

      setState(() {
        currentAddress = "${place.street}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      print({"error": e});
      _showMessage("Error getting location $e");
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
          'Report Crime',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crime Type',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: selectedCrime,
                    hint: const Text('Select Crime Type'),
                    items:
                        crimeTypes
                            .map(
                              (crime) => DropdownMenuItem(
                                value: crime,
                                child: Text(crime),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => selectedCrime = value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe the crime...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Nearest Police Station',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: selectedPoliceStation,
                    hint: const Text('Select nearest police station'),
                    items:
                        policeStations
                            .map(
                              (station) => DropdownMenuItem(
                                value: station,
                                child: Text(station),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) =>
                            setState(() => selectedPoliceStation = value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Upload Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: const Text(
                        'Upload Evidence (if any)',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Image Preview
                  _selectedImage != null
                      ? Image.file(_selectedImage!, height: 150)
                      : const Text("No image selected"),

                  const SizedBox(height: 16),

                  // Anonymous
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.visibility_off, size: 20),
                          SizedBox(width: 8),
                          Text('Anonymous Report'),
                        ],
                      ),
                      Switch(
                        value: anonymous,
                        onChanged: (value) => setState(() => anonymous = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Location (placeholder)
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF1E88E5)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Current Location: $currentAddress",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Submit Report',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
