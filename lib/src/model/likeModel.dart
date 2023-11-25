class LikeModel {
  final String videoId; // Khóa ngoại tới bảng Videos
  final String userId; // Khóa ngoại tới bảng Users
  final bool isLiked; // Đánh dấu nếu người dùng thích video

  LikeModel({
    required this.videoId,
    required this.userId,
    required this.isLiked,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory LikeModel.fromMap(Map<String, dynamic> data) {
    return LikeModel(
      videoId: data['videoId'],
      userId: data['userId'],
      isLiked: data['isLiked'],
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'userId': userId,
      'isLiked': isLiked,
    };
  }
}
