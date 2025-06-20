import 'package:flutter/material.dart';
import 'package:onboard_app/constants/onboard_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingInfo info;

  const OnboardingPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        _OnboardingImage(imagePath: info.image, height: height * 0.60),
        const SizedBox(height: 0.5),
        _OnboardingText(title: info.title, description: info.description),
      ],
    );
  }
}

class _OnboardingImage extends StatelessWidget {
  final String imagePath;
  final double height;

  const _OnboardingImage({
    required this.imagePath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _OnboardingText extends StatelessWidget {
  final String title;
  final String description;

  const _OnboardingText({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
