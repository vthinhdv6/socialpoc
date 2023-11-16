import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: TikTokProfileScreen(),
    );
  }
}
class TikTokProfileScreen extends StatelessWidget {
  final VideoController videoController = Get.put(VideoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage('https://example.com/your_profile_image.jpg'),
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
            child: GetBuilder<VideoController>(
              builder: (controller) => ListView.builder(
                itemCount: controller.videos.length,
                itemBuilder: (context, index) {
                  // Chỉ hiển thị video của người dùng đang đăng nhập
                  if (controller.videos[index].user == FirebaseAuth.instance.currentUser?.uid) {
                    return Container(
                      height: 50.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Chewie(
                        controller: ChewieController(
                          videoPlayerController: VideoPlayerController.network(
                            controller.videos[index].url,
                          ),
                          autoPlay: false,
                          looping: false,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
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
                  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                  await videoController.uploadVideo(videoFile, userId);
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
}
