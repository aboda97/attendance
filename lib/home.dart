import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationAlert();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission requestedPermission =
          await Geolocator.requestPermission();
      if (requestedPermission == LocationPermission.denied ||
          requestedPermission == LocationPermission.deniedForever) {
        _showLocationAlert();
        return;
      }
    }

    setState(() {
      _isLocationEnabled = true;
    });
  }

  void _showLocationAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Required"),
        content: const Text("Please enable location services to check in."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _onCheckInPressed() async {
    if (_isLocationEnabled) {
      Position position = await Geolocator.getCurrentPosition();
      // Handle the check-in logic here using the `position`.
      log("Checked in at: ${position.latitude}, ${position.longitude}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Check-In"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isLocationEnabled ? _onCheckInPressed : null,
          child: const Text("Check In"),
        ),
      ),
    );
  }
}
