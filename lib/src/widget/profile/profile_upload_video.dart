import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../model/video.dart';
import 'profile_controller.dart';
import 'package:chewie/chewie.dart';

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoController>(
      init: VideoController(),
      builder: (videoController) {
        return MaterialApp(
          title: 'Profile',
          home: VideoList(videoController: videoController),
        );
      },
    );
  }
}

class VideoList extends StatelessWidget {
  final VideoController videoController;

  VideoList({required this.videoController});

  @override
  Widget build(BuildContext context) {
    VideoPlayerController? controller = videoController.controller;
    List<VideoModel> videos = videoController.videos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            controller!.value.isInitialized
                ? Chewie(
                    controller: ChewieController(
                      videoPlayerController: controller,
                      autoPlay: true,
                      looping: true,
                    ),
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
                    String? videoUrl =
                        await videoController.uploadVideo(videoFile, videoController.userId);
                    print('Video URL  upload: $videoUrl');
                    if (videoUrl != null) {
                      print('Video URL after upload: $videoUrl');
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
                await videoController.updateUserName();
              },
              child: const Text('Update User Email'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'User Videos:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  // Chỉ hiển thị video của người dùng đang đăng nhập
                  if (videoController.videos[index].user == videoController.userId) {
                    return ListTile(
                      title: Text('Video ${index + 1}'),
                      subtitle: Chewie(
                        controller: ChewieController(
                          videoPlayerController: VideoPlayerController.network(
                            videos[index].url,
                          ),
                          autoPlay: false,
                          looping: false,
                        ),
                      ),
                    );
                  } else {
                    // Nếu không phải video của người dùng, hiển thị một widget khác hoặc null
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
