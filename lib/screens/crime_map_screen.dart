import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CrimeMapScreen extends StatefulWidget {
  const CrimeMapScreen({super.key});

  @override
  State<CrimeMapScreen> createState() => _CrimeMapScreenState();
}

class _CrimeMapScreenState extends State<CrimeMapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(6.5244, 3.3792); // Lagos

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('crime1'),
      position: LatLng(6.5244, 3.3792),
      infoWindow: InfoWindow(
        title: 'Robbery',
        snippet: 'Victoria Island, Lagos',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    ),
    Marker(
      markerId: MarkerId('crime2'),
      position: LatLng(6.4654, 3.4064),
      infoWindow: InfoWindow(
        title: 'Assault',
        snippet: 'Surulere, Lagos',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    ),
    Marker(
      markerId: MarkerId('crime3'),
      position: LatLng(6.6018, 3.3515),
      infoWindow: InfoWindow(
        title: 'Theft (Resolved)',
        snippet: 'Ikeja, Lagos',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Crime Map',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}
