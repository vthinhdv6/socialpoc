import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: TikTokProfileScreen(),
    );
  }
}
class TikTokProfileScreen extends StatefulWidget {
  @override
  _TikTokProfileScreenState createState() => _TikTokProfileScreenState();
}

class _TikTokProfileScreenState extends State<TikTokProfileScreen> {
  List<String> _videos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phần thông tin cá nhân
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(
                      'https://example.com/your_profile_image.jpg'),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text('Đang follow'),
                        Text('Follower'),
                        Text('Thích'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Sửa hồ sơ'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Chia sẻ hồ sơ'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Thêm bạn'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 200.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.play_arrow, size: 50.0),
                      onPressed: () {
                        // Xử lý khi nhấn vào video
                      },
                    ),
                  ),
                );
              },
            ),
          ),
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
                  await _uploadVideo(videoFile);
                } else {
                  print('Error: selectedFile.path is null.');
                }
              }
            },
            child: Text('Chọn và Upload Video'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadVideo(File videoFile) async {
    try {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now()}.mp4');

      firebase_storage.UploadTask uploadTask =
      storageReference.putFile(videoFile);

      await uploadTask.whenComplete(() => null);

      String videoUrl = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance.collection('videos').add({
        'url': videoUrl,
        'user': 'doanthinh20@gmail.com',
      });

      setState(() {
        _videos.add(videoUrl);
      });

      print('Video URL after upload: $videoUrl');
    } catch (e) {
      print('Error uploading video: $e');
    }
  }
}
