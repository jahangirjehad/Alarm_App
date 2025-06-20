import 'package:flutter/material.dart';
import 'features/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
