import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isButtonEnabled = false;
  late StreamSubscription<ServiceStatus> _locationServiceStatusStream;

  @override
  void initState() {
    super.initState();
    _checkInitialLocationStatus();
    _listenToLocationServiceChanges();
  }

  @override
  void dispose() {
    _locationServiceStatusStream.cancel();
    super.dispose();
  }

  /// Check the initial status of location services
  Future<void> _checkInitialLocationStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isButtonEnabled = serviceEnabled;
    });
  }

  /// Listen to location service status changes
  void _listenToLocationServiceChanges() {
    _locationServiceStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        // Location services are turned on
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        // Location services are turned off
        setState(() {
          _isButtonEnabled = false;
        });
      }
    });
  }

  /// Handle button press
  Future<void> _onCheckInPressed() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      DateTime now = DateTime.now();
      log("Checked in at: ${now.toString()}");
      log("Checked in at: ${position.latitude}, ${position.longitude}");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thank You!"),
          content: Text("Check-in successful. Have a great day!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Check-In"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isButtonEnabled ? _onCheckInPressed : null,
          child: Text("Check In"),
        ),
      ),
    );
  }
}
