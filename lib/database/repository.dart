import 'package:scheduled_notifications/database/db_helper.dart';
import 'package:scheduled_notifications/model/notification_time.dart';

class Repository {
  final _dbHelper = DBHelper.dbHero;

  Future<List<NotificationTime>> getAllTimes() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.readDb();
    return List.generate(maps.length, (i) {
      return NotificationTime(id: maps[i]['id'], time: maps[i]['time']);
    });
  }

  Future<int> insert(NotificationTime time) async {
    return await _dbHelper.insertDb(time.toMap());
  }

  Future<int> update(NotificationTime time) async {
    return await _dbHelper.updateDb(time.toMap());
  }

  Future<int> delete(int id) async {
    return await _dbHelper.deleteDb(id);
  }
}