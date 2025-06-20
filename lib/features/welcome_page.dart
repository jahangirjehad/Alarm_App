import 'package:flutter/material.dart';
import 'package:onboard_app/features/alarm_page.dart';

import '../helpers/location_logic.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _locationMessage = "Selected Location";

  Future<void> _handleCurrentLocation() async {
    final address = await LocationHelper.getCurrentLocation();
    setState(() {
      _locationMessage = "Selected Location: $address";
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AlarmPage(location: _locationMessage),
      ),
    );
  }

  void _handleHomeLocation() {
    setState(() {
      _locationMessage = "Selected Location: Home";
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AlarmPage(location: _locationMessage),
      ),
    );
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
            const SizedBox(height: 10),
            Text(
              'Allow us to sync your sunset alarm based on your location.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/img4.png'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleCurrentLocation,
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
                  SizedBox(
                    width: width * 0.40,
                    child: const Text('Use Current Location'),
                  ),
                  const Icon(Icons.location_pin, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _handleHomeLocation,
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
            const SizedBox(height: 20),
            Text(
              _locationMessage,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
