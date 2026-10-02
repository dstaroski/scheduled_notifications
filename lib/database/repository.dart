import 'package:scheduled_notifications/database/db_helper.dart';
import 'package:scheduled_notifications/model/notification_time.dart';

class Repository {
  final _dbHelper = DBHelper.dbHero;

  Future<List<NotificationTime>> getAllTimes() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getAllTimes();
    return List.generate(maps.length, (i) {
      return NotificationTime(
        id: maps[i]['id'],
        time: maps[i]['time'],
        description: maps[i]['description'],
      );
    });
  }

  Future<int> insertTime(NotificationTime time) async {
    return await _dbHelper.insertTime(time.toMap());
  }

  Future<int> updateTime(NotificationTime time) async {
    return await _dbHelper.updateTime(time.toMap());
  }

  Future<int> deleteTime(int id) async {
    return await _dbHelper.deleteTime(id);
  }
}