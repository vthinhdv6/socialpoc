import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
  String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(videoController.avatarUrl),
              ),
              Positioned(
                child: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null && result.files.isNotEmpty) {
                        final selectedFile = result.files.single;
                        if (selectedFile.path != null) {
                          print('Selected Image Path: ${selectedFile.path}');
                          File imageFile = File(selectedFile.path!);
                          String userId =
                              FirebaseAuth.instance.currentUser?.uid ?? '';
                          await videoController.uploadAvatar(imageFile, userId);
                        } else {
                          print('Error: selectedFile.path is null.');
                        }
                      }
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ],
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

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: (videoController.videos.length / 3).ceil(),
              itemBuilder: (context, pageIndex) {
                return SizedBox(
                  height: 200.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                          (index) {
                        final videoIndex = pageIndex * 3 + index;
                        if (videoIndex < videoController.videos.length &&
                            videoController.videos[videoIndex].user ==
                                FirebaseAuth.instance.currentUser?.uid) {
                          return Container(
                            height: 150.0,
                            width: MediaQuery.of(context).size.width / 3 - 3,
                            margin: EdgeInsets.symmetric(horizontal: 0.7),
                            child: Chewie(
                              controller: ChewieController(
                                videoPlayerController: VideoPlayerController.network(
                                  videoController.videos[videoIndex].url,
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
