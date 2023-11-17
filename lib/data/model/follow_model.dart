import 'package:equatable/equatable.dart';

class FollowModel extends Equatable {
  final String idUserFollowing;
  final String idUserFollown;

  const FollowModel(this.idUserFollowing, this.idUserFollown);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
