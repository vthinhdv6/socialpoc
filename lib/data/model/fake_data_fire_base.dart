import 'dart:math';

import 'package:socialpoc/data/model/comment_model.dart';
import 'package:socialpoc/data/model/tym_view_model.dart';
import 'package:socialpoc/data/model/user_view_model.dart';
import 'package:socialpoc/src/model/UserModel.dart';

List<CommentModel> fakeDataComment() {
  const idUser = 'Yvm6Hb7R3PhmPKic6FKM';
  const idVideo = '5BdnPeKP28p42FnX4shK';
  List<CommentModel> listFakeCommentData = List.generate(3, (index) {
    return CommentModel('1', idUser, idVideo, 'Binh luan tu thu thao', DateTime.now());
  });
  return listFakeCommentData;
}

List<CommentModel> fakeDataFollow() {
  const idUser = 'Yvm6Hb7R3PhmPKic6FKM';
  const idVideo = '5BdnPeKP28p42FnX4shK';
  List<CommentModel> listFakeCommentData = List.generate(3, (index) {
    return CommentModel('1', idUser, idVideo, 'Binh luan tu thu thao', DateTime.now());
  });
  return listFakeCommentData;
}

UserModel generateFakeUser() {
  final random = Random();
  const email = 'thuthao1110@gmail.com';
  const age = 21;
  const userName = 'default';
  const avatarUrl = 'https://th.bing.com/th/id/OIP.tyKHoj6bosTXEOY9hUFz7QHaHa?rs=1&pid=ImgDetMain';
  const List<String> listStringContent = ['null'];
  return UserModel(
    email: email,
    age: age,
    userName: userName,
    avatarUrl: avatarUrl,
    followers: listStringContent,
    likedVideos: listStringContent,
    following: listStringContent,
    videos: listStringContent,
  );
}

List<TymVideo> fakeDataTymVideo() {
  const idUser = 'Yvm6Hb7R3PhmPKic6FKM';
  const idVideo = '5BdnPeKP28p42FnX4shK';
  List<TymVideo> listFakeTym = List.generate(1, (index) {
    return const TymVideo(idUser, idVideo);
  });
  return listFakeTym;
}
