class UserModel {
  final String userId;
  final String userName;
  final String avatarUrl;
  final String email;
  final int age;
  final List<String> followers;
  final List<String> following;
  final List<String> videos;
  final List<String> likedVideos;
  UserModel({
    required this.email,
    required this.age,
    required this.userId,
    required this.userName,
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
      userName: data['username'],
      avatarUrl: data['avatarUrl'],
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      videos: List<String>.from(data['videos'] ?? []),
      likedVideos: List<String>.from(data['likedVideos'] ?? []),
      email: data["email"],
      age: data['age'],
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': userName,
      'avatarUrl': avatarUrl,
      'followers': followers,
      'following': following,
      'videos': videos,
      'likedVideos': likedVideos,
      'age': age,
      'email': email,
    };
  }
}
