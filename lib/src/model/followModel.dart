class FollowModel {
  final String followerId; // Khóa ngoại tới bảng Users
  final String followingId; // Khóa ngoại tới bảng Users

  FollowModel({
    required this.followerId,
    required this.followingId,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory FollowModel.fromMap(Map<String, dynamic> data) {
    return FollowModel(
      followerId: data['followerId'],
      followingId: data['followingId'],
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'followerId': followerId,
      'followingId': followingId,
    };
  }
}
