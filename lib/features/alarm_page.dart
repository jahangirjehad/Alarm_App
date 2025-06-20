import 'package:flutter/material.dart';

import 'package:onboard_app/helpers/notification_service.dart';

import '../common_widgets/alarm_tile.dart';
import '../common_widgets/location_display.dart';
import '../constants/alarm_database.dart';


class AlarmPage extends StatefulWidget {
  final String location;
  const AlarmPage({required this.location});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final NotificationService _notificationService = NotificationService();
  final AlarmDatabase _alarmDb = AlarmDatabase();

  List<Map<String, dynamic>> _alarms = [];
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final alarms = await _alarmDb.getAlarms();
    setState(() {
      _alarms = alarms;
    });
  }

  Future<void> _saveAlarm() async {
    if (_selectedTime == null) return;

    await _alarmDb.insertAlarm(_selectedTime!);
    await _notificationService.scheduleNotification(_selectedTime!);
    await _loadAlarms();

    setState(() {
      _selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            LocationDisplay(location: widget.location),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  final now = DateTime.now();
                  _selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                  await _saveAlarm();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                fixedSize: Size(screenWidth * 0.8, 48),
              ),
              child: const Text('Add Alarm'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Alarms', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (context, index) => AlarmTile(
                  alarm: _alarms[index],
                  onToggle: (value) async {
                    await _alarmDb.updateAlarmStatus(_alarms[index]['id'], value);
                    _loadAlarms();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
