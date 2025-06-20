import 'package:flutter/material.dart';

import '../constants/onboard_data.dart';




class OnboardingPage extends StatelessWidget {
  final OnboardingInfo info;

  const OnboardingPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Top Image Container
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: SizedBox(
            height: height * 0.60, // 3/4th of the screen
            width: double.infinity,
            child: Image.asset(
              info.image,
              fit: BoxFit.cover,

            ),
          ),
        ),
        SizedBox(height: 0.5,),
        // Bottom text
        Expanded(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  info.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

