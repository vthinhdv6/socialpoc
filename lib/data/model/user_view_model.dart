import 'package:equatable/equatable.dart';

class UserViewModel extends Equatable {
  final String userId;
  final String email;
  final int age;
  final String userName;
  final String avatarUrl;
  final String pass;

  const UserViewModel({
    required this.userId,
    required this.email,
    required this.age,
    required this.userName,
    required this.avatarUrl,
    required this.pass,
  });
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
