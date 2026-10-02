class NotificationTime {
  int? id;
  String time;
  String description;

  NotificationTime({this.id, required this.time, required this.description});

  Map<String, dynamic> toMap() {
    return {'id': id, 'time': time, 'description': description};
  }
}