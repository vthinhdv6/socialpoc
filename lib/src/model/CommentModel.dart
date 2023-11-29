import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId; // Primary Key
  final String videoId; // Khóa ngoại tới bảng Videos
  final String userId; // Khóa ngoại tới bảng Users
  final String content;
  final DateTime commentTime;

  CommentModel({
    required this.commentId,
    required this.videoId,
    required this.userId,
    required this.content,
    required this.commentTime,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      commentId: data['commentId'],
      videoId: data['videoId'],
      userId: data['userId'],
      content: data['content'],
      commentTime: (data['commentTime'] is Timestamp)
          ? (data['commentTime'] as Timestamp).toDate()
          : DateTime.parse(data['commentTime']),
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'videoId': videoId,
      'userId': userId,
      'content': content,
      'commentTime': commentTime.toUtc().toIso8601String(),
    };
  }
}
