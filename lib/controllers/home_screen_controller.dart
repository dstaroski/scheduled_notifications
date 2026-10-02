import 'package:scheduled_notifications/database/repository.dart';
import '../model/notification_time.dart';

class HomeScreenController {
  final Repository _repository = Repository();

  Future<List<NotificationTime>> getAllTimes() async {
    final times = await _repository.getAllTimes();
    return times;
  }

  Future<int> insertTime(NotificationTime time) async {
    return await _repository.insertTime(time);
  }

  Future<int> updateTime(NotificationTime time) async {
    return await _repository.updateTime(time);
  }

  Future<int> deleteTime(int id) async {
    if(id != 0) {
      return await _repository.deleteTime(id);
    }
    return 0;
  }
}