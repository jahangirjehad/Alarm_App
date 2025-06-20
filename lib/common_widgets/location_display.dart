import 'package:flutter/material.dart';

class LocationDisplay extends StatelessWidget {
  final String location;
  const LocationDisplay({required this.location});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 100, 16, 16),
      height: 100,
      width: screenWidth * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.purple, size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              softWrap: true,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}
