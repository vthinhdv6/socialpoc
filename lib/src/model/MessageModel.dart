class MessageModel {
  final String messageId; // Primary Key
  final String userId; // Khóa ngoại tới bảng Users
  final String content;
  final DateTime messageTime;

  MessageModel({
    required this.messageId,
    required this.userId,
    required this.content,
    required this.messageTime,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      messageId: data['messageId'],
      userId: data['userId'],
      content: data['content'],
      messageTime: DateTime.parse(data['messageTime']),
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'userId': userId,
      'content': content,
      'messageTime': messageTime.toUtc().toIso8601String(),
    };
  }
}
