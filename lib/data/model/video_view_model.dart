import 'package:equatable/equatable.dart';

class VideoViewModel extends Equatable {
  final String urlVideo;
  final String idUserOwner;
  final String captionVideo;
  final DateTime dateTime;
  const VideoViewModel(this.urlVideo, this.idUserOwner, this.captionVideo, this.dateTime);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
