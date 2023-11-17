import 'package:equatable/equatable.dart';

class CommentModel extends Equatable{
  final String idCmt;
  final String idUser;
  final String idVideo;
  final String content;
  final DateTime dateTime;

  const CommentModel(this.idCmt, this.idUser, this.idVideo, this.content, this.dateTime);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}