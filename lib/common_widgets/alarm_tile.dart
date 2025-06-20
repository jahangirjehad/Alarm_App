import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  final Map<String, dynamic> alarm;
  final Function(bool) onToggle;

  const AlarmTile({required this.alarm, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${alarm['time']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 4),
                Text('${alarm['date']}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            Switch(
              value: alarm['isActive'] == 1,
              onChanged: onToggle,
              activeColor: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
