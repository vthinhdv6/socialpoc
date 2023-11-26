import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/videoModel.dart';

class UpLoadVideoController {
  final CollectionReference _videosCollection = FirebaseFirestore.instance.collection('videos');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> uploadVideo(String userId, String title, String videoPath, String caption) async {
    try {
      // Upload video to Firebase Storage
      String videoId = DateTime.now().millisecondsSinceEpoch.toString();
      Reference videoRef = _storage.ref().child('videos/$videoId.mp4');
      await videoRef.putFile(File(videoPath));

      // Get video URL
      String videoUrl = await videoRef.getDownloadURL();

      // Create VideoModel object
      VideoModel newVideo = VideoModel(
        videoId: videoId,
        userId: userId,
        title: title,
        url: videoUrl,
        likes: 0,
        comments: [],
        uploadTime: DateTime.now(),
      );

      // Upload video data to Firestore
      await _videosCollection.doc(videoId).set(newVideo.toMap());

      // TODO: Upload caption to Firestore or handle it as needed
      // ...

      print('Video uploaded successfully!');
    } catch (error) {
      print('Error uploading video: $error');
      // Handle error as needed
    }

  }
}