import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduled_notifications/database/repository.dart';
import 'package:scheduled_notifications/model/notification_time.dart';
import 'package:scheduled_notifications/service/notification_service.dart';
import 'package:scheduled_notifications/menu/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Repository _repository = Repository();

  List<NotificationTime> _times = [];

  @override
  void initState() {
    super.initState();
    _getTimes();
  }

  // Retrieves all schedules from the database.
  void _getTimes() async {
    final times = await _repository.getAllTimes();
    setState(() {
      _times = times;
    });
  }

  // Add a schedule on database.
  void _addTime(String selectedTime) async {
    if (selectedTime.isNotEmpty) {
      final time = NotificationTime(time: selectedTime);
      final int generatedId = await _repository.insert(time);
      await _timeSchedule(generatedId, time.time);
      _getTimes();
    }
  }

  // Update a schedule on database.
  void _updateTime(int? id, String selectedTime) async {
    final updatedNotificationTime = NotificationTime(
      id: id,
      time: selectedTime,
    );
    await _repository.update(updatedNotificationTime);
    await _timeSchedule(id ?? 0, selectedTime);
    _getTimes();
  }

  // Delete a schedule on database.
  void _deleteTime(int id) async {
    await NotificationService().cancel(id);
    await _repository.delete(id);
    _getTimes();
  }

  // Open a native timepicker on android and capture the time.
  Future<void> _openTimeSelector(int id, bool add) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final formatedTime = await _formatTime(selectedTime);

      if (add) {
        _addTime(formatedTime);
      } else {
        _updateTime(id, formatedTime);
      }
    }
  }

  // Format the time in a specific pattern.
  Future<String> _formatTime(TimeOfDay time) async {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // Schedule a time on flutter local notification plugin.
  Future<void> _timeSchedule(int id, String time) async {
    if (time.isNotEmpty && id != 0) {
      final split = time.split(':');
      final hour = int.parse(split[0]);
      final minute = int.parse(split[1]);

      await NotificationService().scheduleDailyNotification(
        id: id,
        title: 'Notification title',
        body: 'Here is the text of your notification!',
        hour: hour,
        minute: minute,
      );
    }
  }

  // Check scheduled notifications - useful for tests.
  Future<void> checkPendingNotifications() async {
    final pending = await FlutterLocalNotificationsPlugin()
        .pendingNotificationRequests();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Scheduled: ${pending.length}'),
          content: SizedBox(
            width: double.maxFinite,
            child: pending.isEmpty
              ? const Text('No notifications in the queue.')
              : ListView.builder(
                shrinkWrap: true,
                itemCount: pending.length,
                itemBuilder: (context, index) {
                  final item = pending[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      'ID: ${item.id} - ${item.title ?? "No title"}',
                    ),
                    subtitle: Text(item.body ?? 'No text'),
                  );
                },
              ),
            ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scheduled Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4368EC), Color(0xFF13299A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(selectedIndex: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Add a hour:',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.add_circle,
                size: 50.0,
                color: Color(0xFF4368EC),
              ),
              onPressed: () => _openTimeSelector(0, true),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _times.length,
              itemBuilder: (context, index) {
                final time = _times[index];
                return Card(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.notifications),
                          Text(
                            'Set Time: ${time.time}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                _openTimeSelector(time.id ?? 0, false),
                          ),
                        ],
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Delete appointment'),
                          content: Text('Are you sure?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteTime(time.id ?? 0);
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}