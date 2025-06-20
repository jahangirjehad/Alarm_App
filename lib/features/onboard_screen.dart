import 'package:flutter/material.dart';
import 'package:onboard_app/features/onboard_page.dart';
import 'package:onboard_app/features/welcome_page.dart';


import '../constants/onboard_data.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void _nextPage() {
    if (currentIndex < onboardingPages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => WelcomePage()));
    }
  }

  void _skip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingPages.length,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (_, index) => OnboardingPage(info: onboardingPages[index]),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _skip,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _nextPage,
                    child: const Center(child: Text('Next',style: TextStyle(color: Colors.white),)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
