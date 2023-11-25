class UserModel {
  final String userId;
  final String username;
  final String avatarUrl;
  final List<String> followers;
  final List<String> following;
  final List<String> videos;
  final List<String> likedVideos;
  UserModel({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.followers,
    required this.following,
    required this.videos,
    required this.likedVideos,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'],
      username: data['username'],
      avatarUrl: data['avatarUrl'],
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      videos: List<String>.from(data['videos'] ?? []),
      likedVideos: List<String>.from(data['likedVideos'] ?? []),
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'followers': followers,
      'following': following,
      'videos': videos,
      'likedVideos': likedVideos,
    };
  }
}
