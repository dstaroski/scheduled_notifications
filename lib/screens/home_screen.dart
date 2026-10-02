import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:scheduled_notifications/controllers/home_screen_controller.dart';
import 'package:scheduled_notifications/model/notification_time.dart';
import 'package:scheduled_notifications/service/notification_service.dart';
import 'package:scheduled_notifications/menu/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController _homeScreenController = HomeScreenController();
  final TextEditingController _descriptionController = TextEditingController();

  List<NotificationTime> _times = [];
  bool canEdit = false;
  bool hasTimes = false;
  int updateId = 0;

  @override
  void initState() {
    super.initState();
    _getAllTimes();
  }

  // Retrieves all schedules from the database.
  void _getAllTimes() async {
    final times = await _homeScreenController.getAllTimes();
    hasTimes = times.isNotEmpty;

    setState(() {
      _times = times;
    });
  }

  // Add a schedule on database.
  void _insertTime(String selectedTime) async {
    if (_descriptionController.text.isNotEmpty) {
      if(selectedTime.isNotEmpty) {
        final time = NotificationTime(
          time: selectedTime,
          description: _descriptionController.text,
        );
        final int generatedId = await _homeScreenController.insertTime(time);
        await _timeSchedule(generatedId, time.time, time.description);
        _descriptionController.clear();
        _getAllTimes();
        _showSuccessAnimation();
      } else {
        _showSnackBar('The selected time cannot be empty.');
      }
    } else {
      _showSnackBar('The description field cannot be empty.');
    }
  }

  // Update a schedule on database.
  void _updateTime(int? id, String selectedTime) async {
    if(id != 0 && selectedTime.isNotEmpty
      && _descriptionController.text.isNotEmpty) {
      final updatedNotificationTime = NotificationTime(
        id: id,
        time: selectedTime,
        description: _descriptionController.text,
      );
      await _homeScreenController.updateTime(updatedNotificationTime);
      await _timeSchedule(id ?? 0, selectedTime, updatedNotificationTime.description);
      _getAllTimes();
      _cancelEdit();
      _showSuccessAnimation();
    } else {
      _showSnackBar('An error occurred during the update.');
    }
  }

  // Delete a schedule on database.
  void _deleteTime(int id) async {
    if(id != 0) {
      await NotificationService().cancel(id);
      await _homeScreenController.deleteTime(id);
      _getAllTimes();
      _cancelEdit();
      _showSuccessAnimation();
    } else {
      _showSnackBar('An error occurred during the delete.');
    }
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
        _insertTime(formatedTime);
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
  Future<void> _timeSchedule(int id, String time, String description) async {
    if (time.isNotEmpty && id != 0) {
      final split = time.split(':');
      final hour = int.parse(split[0]);
      final minute = int.parse(split[1]);

      await NotificationService().scheduleDailyNotification(
        id: id,
        title: 'Hello! notification for you \u{1F600}!',
        body: description,
        hour: hour,
        minute: minute,
      );
    }
  }

  void _showSnackBar(String text) {
    if(!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          child: Lottie.asset(
            'assets/animations/check_hover_pinch.json',
            repeat: false,
            width: 50,
            height: 50,
            onLoaded: (composition) {
              Future.delayed(composition.duration, () {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              });
            }
          ),
        );
      },
    );
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

  void _canEdit(NotificationTime time) {
    setState(() {
      canEdit = true;
      _descriptionController.text = time.description;
      updateId = time.id ?? 0;
    });
  }

  void _cancelEdit() {
    setState(() {
      canEdit = false;
      _descriptionController.clear();
      updateId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Colors.blueGrey;

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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              controller: _descriptionController,
              maxLength: 35,
            )
          ),
          !canEdit ? IconButton(
            onPressed: () => _openTimeSelector(0, true),
            icon: Icon(Icons.add),
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: theme,
            ),
          )
          :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _cancelEdit(),
                icon: Icon(Icons.cancel),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: theme,
                ),
              ),
              SizedBox(width: 16.0),
              IconButton(
                onPressed: () => _openTimeSelector(updateId, false),
                icon: Icon(Icons.save),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: theme,
                ),
              ),
            ],
          ),
          Expanded(
            child: hasTimes ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
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
                          Column(
                            children: [
                              Text('${time.description}'),
                              Text(
                                '${time.time}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _canEdit(time),
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
            )
            : Lottie.asset(
              'assets/animations/squirrel_hover_pinch.json',
              height: 200,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}