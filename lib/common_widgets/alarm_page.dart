import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  final String location;

  AlarmPage({required this.location});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> _alarms = [];
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadAlarms();
  }

  Future<void> _initializeNotifications() async {



    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request exact alarm permission
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'alarms_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE alarms(id INTEGER PRIMARY KEY, time TEXT, date TEXT, isActive INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> _loadAlarms() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('alarms');
    setState(() {
      _alarms = maps;
    });
  }

  Future<void> _saveAlarm() async {
    if (_selectedTime == null) return;
    final db = await _getDatabase();
    await db.insert(
      'alarms',
      {
        'time': DateFormat('h:mm a').format(_selectedTime!),
        'date': DateFormat('EEE dd MMM yyyy').format(_selectedTime!),
        'isActive': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _scheduleNotification(_selectedTime!);
    await _loadAlarms();
    setState(() {
      _selectedTime = null;
    });
  }

  Future<void> _scheduleNotification(DateTime time) async {
    debugPrint('Input time: ${time.toString()}');
    if (time.isBefore(DateTime.now())) {
      time = time.add(const Duration(days: 1));
      debugPrint('Adjusted time (past): ${time.toString()}');
    }
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(time, tz.local);
    debugPrint('Scheduling alarm for: ${scheduledTime.toString()}');

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'This channel is used for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Alarm',
        'Time to wake up!',
        notificationDetails,
      );
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Use a unique ID (e.g., based on db id) to avoid overwriting
        'Alarm',
        'Time to wake up!',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Notification scheduled successfully for ${scheduledTime.toString()}');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      if (e.toString().contains('exact_alarms_not_permitted')) {
        debugPrint('Falling back to inexact scheduling');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Alarm',
          'Time to wake up!',
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        debugPrint('Inexact notification scheduled for ${scheduledTime.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16,100,16,16),
              height: 100,
              width: screenWidth*.8,

              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A), // dark background color
                borderRadius: BorderRadius.zero, // rectangular shape
                border: Border.all(color: Colors.grey), // optional border
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.purple, size: 50,),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.location,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      softWrap: true,
                      overflow: TextOverflow.visible, // or remove this line entirely
                      maxLines: null, // allow unlimited lines
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 16),


    ElevatedButton(
      onPressed: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          final DateTime now = DateTime.now();
          setState(() {
            _selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
          });
          await _saveAlarm();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        fixedSize: Size(screenWidth * 0.8, 48), // 80% width and 48 height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // rectangle shape
        ),
      ),
      child: const Text('Add Alarm'),
    ),

    SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Alarms',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  final alarm = _alarms[index];
                  final screenWidth = MediaQuery.of(context).size.width;

                  return Center( // to center the 80% width container
                    child: Container(
                      width: screenWidth * 0.9,
                      margin: EdgeInsets.symmetric(vertical: 8), // spacing between items
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.zero, // Rectangle
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time and Date Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${alarm['time']}',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${alarm['date']}',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          // Active Switch
                          Switch(
                            value: alarm['isActive'] == 1,
                            onChanged: (bool value) async {
                              final db = await _getDatabase();
                              await db.update(
                                'alarms',
                                {'isActive': value ? 1 : 0},
                                where: 'id = ?',
                                whereArgs: [alarm['id']],
                              );
                              _loadAlarms();
                            },
                            activeColor: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}