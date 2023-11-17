import 'package:socialpoc/data/model/comment_model.dart';

List<CommentModel> fakeDataComment(){
  const idUser = 'Yvm6Hb7R3PhmPKic6FKM';
  const idVideo = '5BdnPeKP28p42FnX4shK';
  List<CommentModel> listFakeCommentData = List.generate(3, (index){
    return CommentModel('1', idUser, idVideo, 'Binh luan tu thu thao', DateTime.now());
  });
  return listFakeCommentData;
}