import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/video.dart';

class FirestoreService {
  final CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');

  Future<List<VideoModel>> getVideos() async {
    QuerySnapshot querySnapshot = await videosCollection.get();
    List<VideoModel> videos = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      videos.add(VideoModel(url: data['url'], user: data['user']));
    }


    return videos;
  }
}
