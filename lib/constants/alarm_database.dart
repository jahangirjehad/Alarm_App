import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class AlarmDatabase {
  Future<Database> _getDb() async {
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

  Future<List<Map<String, dynamic>>> getAlarms() async {
    final db = await _getDb();
    return db.query('alarms');
  }

  Future<void> insertAlarm(DateTime time) async {
    final db = await _getDb();
    await db.insert(
      'alarms',
      {
        'time': DateFormat('h:mm a').format(time),
        'date': DateFormat('EEE dd MMM yyyy').format(time),
        'isActive': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAlarmStatus(int id, bool isActive) async {
    final db = await _getDb();
    await db.update(
      'alarms',
      {'isActive': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
