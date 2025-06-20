class OnboardingInfo {
  final String image;
  final String title;
  final String description;

  OnboardingInfo({
    required this.image,
    required this.title,
    required this.description,
  });
}

final onboardingPages = [
  OnboardingInfo(
    image: 'assets/img1.gif', // Place this image in assets
    title: 'Sync with Nature’s Rhythm',
    description:
    'Experience a peaceful transition into the evening with an alarm that aligns with the sunset. Your perfect reminder, always 15 minutes before sundown',
  ),
  OnboardingInfo(
    image: 'assets/img2.gif',
    title: 'Effortless & Automatic',
    description:
    'No need to set alarms manually. Wakey calculates the sunset time for your location and alerts you on time.',
  ),
  OnboardingInfo(
    image: 'assets/img3.gif',
    title: 'Relax & Unwind',
    description:
    'hope to take the courage to pursue your dreams.',
  ),
];
