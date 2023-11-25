class NotificationModel {
  final String notificationId; // Primary Key
  final String userId; // Khóa ngoại tới bảng Users
  final String content;
  final DateTime timestamp;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      notificationId: data['notificationId'],
      userId: data['userId'],
      content: data['content'],
      timestamp: DateTime.parse(data['timestamp']),
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }
}
