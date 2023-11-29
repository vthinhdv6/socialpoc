import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialpoc/src/model/CommentModel.dart';

class VideoModel {
  final String videoId;
  final String userId; // Khóa ngoại tới bảng Users
  final String title;
  final String url;
  int likes;
  final List<CommentModel> comments;
  final DateTime uploadTime;

  VideoModel({
    required this.videoId,
    required this.userId,
    required this.title,
    required this.url,
    required this.likes,
    required this.comments,
    required this.uploadTime,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory VideoModel.fromMap(Map<String, dynamic> data) {
    return VideoModel(
      videoId: data['videoId'],
      userId: data['userId'],
      title: data['title'],
      url: data['url'],
      likes: data['likes'],
      comments: List<CommentModel>.from(
        (data['comments'] ?? []).map((comment) => CommentModel.fromMap(comment)),
      ),
      uploadTime: (data['uploadTime'] as Timestamp).toDate(),
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'userId': userId,
      'title': title,
      'url': url,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'uploadTime': uploadTime,
    };
  }
}

