import 'package:equatable/equatable.dart';

class FollowModel extends Equatable {
  //id user
  final String idUserFollowing;
  final String idUserFollower;


  const FollowModel(this.idUserFollowing, this.idUserFollower);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
