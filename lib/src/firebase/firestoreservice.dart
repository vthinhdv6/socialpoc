import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/CommentModel.dart';
import '../model/videoModel.dart'; // Đảm bảo bạn đã import đúng đường dẫn

class FirestoreService {
  final CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');

  Future<List<VideoModel>> getVideos() async {
    QuerySnapshot querySnapshot = await videosCollection.get();
    List<VideoModel> videos = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      videos.add(VideoModel(
        videoId: data['videoId'],
        userId: data['userId'],
        title: data['title'],
        url: data['url'],
        likes: data['likes'],
        comments: List<CommentModel>.from(
          (data['comments'] ?? []).map((comment) => CommentModel.fromMap(comment)),
        ),
        uploadTime: (data['uploadTime'] as Timestamp).toDate(),
      ));
    }

    return videos;
  }
}
