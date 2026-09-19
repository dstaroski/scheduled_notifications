class NotificationTime {
  int? id;
  String time;

  NotificationTime({this.id, required this.time});

  Map<String, dynamic> toMap() {
    return {'id': id, 'time': time};
  }
}