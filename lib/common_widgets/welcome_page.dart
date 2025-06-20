import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:onboard_app/common_widgets/alarm_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _locationMessage = "Selected Location";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permission permanently denied.";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Lat: ${position.latitude}, Long: ${position.longitude}";
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address = "${place.name}, ${place.locality}, ${place.administrativeArea}";
      }

      setState(() {
        _locationMessage = "Selected Location: $address";
      });

      // Navigate to AlarmPage after fetching location
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AlarmPage(location: _locationMessage),
        ),
      );
    } catch (e) {
      setState(() {
        _locationMessage = "Error getting location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome! Your Personalized Alarm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Allow us to sync your sunset alarm based on your location.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/img4.png'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _getLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4D4D4D),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                fixedSize: Size(buttonWidth, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * .40,
                    child: Text('Use Current Location'),
                  ),
                  Icon(Icons.location_pin, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _locationMessage = "Selected Location: Home";
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlarmPage(location: _locationMessage),
                    ),
                  );
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                minimumSize: Size(buttonWidth, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                backgroundColor: Color(0xFF4D4D4D),
              ),
              child: const Text('Home'),
            ),
            SizedBox(height: 20),
            Text(
              _locationMessage,
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
