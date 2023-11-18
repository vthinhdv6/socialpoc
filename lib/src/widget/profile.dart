import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  VideoPlayerController? _controller;
  String? _videoUrl;
  String userName = 'thinh'; // Change this to the corresponding user's name

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(''));
    _controller!.initialize().then((_) {
      setState(() {});
    });
  }

  Future<String?> uploadVideo(File videoFile, String userName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot userSnapshot = await firestore.collection('user').doc(userName).get();

      if (!userSnapshot.exists) {
        await firestore.collection('user').doc(userName).set({
          'name': userName,
        });
      }

      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child('videos/${DateTime.now()}.mp4');

      firebase_storage.UploadTask uploadTask = storageReference.putFile(videoFile);

      await uploadTask.whenComplete(() => null);

      String videoUrl = await storageReference.getDownloadURL();

      await firestore.collection('videos').add({
        'url': videoUrl,
        'user': userName,
      });

      return videoUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  Future<void> updateUserName() async {
    try {
      // Update the name property of the user document
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('user').doc(userName).update({'name': 'thinh_updated'});
      print('User name updated successfully.');
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Container(),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                );
                if (result != null && result.files.isNotEmpty) {
                  final selectedFile = result.files.single;
                  if (selectedFile.path != null) {
                    print('Selected File Path: ${selectedFile.path}');
                    File videoFile = File(selectedFile.path!);
                    String? videoUrl = await uploadVideo(videoFile, userName);
                    print('Video URL  upload: $videoUrl');
                    if (videoUrl != null) {
                      print('Video URL after upload: $videoUrl');
                      setState(() {
                        _videoUrl = videoUrl;
                        _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
                        _controller!.initialize().then((_) {
                          setState(() {});
                        });
                      });
                    } else {
                      print('Error uploading video.');
                    }
                  } else {
                    print('Error: selectedFile.path is null.');
                  }
                }
              },
              child: const Text('Upload Video'),
            ),
            ElevatedButton(
              onPressed: () async {
                await updateUserName();
              },
              child: const Text('Update User Name'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
