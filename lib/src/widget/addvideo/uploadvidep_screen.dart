import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/common/widget/buttonCommonWidget.dart';
import 'package:socialpoc/common/widget/tab_bar_widget.dart';
import 'package:video_player/video_player.dart';
import '../profile/profile_controller.dart';
import 'package:video_player/video_player.dart';

import 'showvideo_screen.dart';



class TikTokProfileScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TikTokProfileScreen1(),
    );
  }
}

class TikTokProfileScreen1 extends StatefulWidget {
  @override
  _TikTokProfileScreen1State createState() => _TikTokProfileScreen1State();
}

class _TikTokProfileScreen1State extends State<TikTokProfileScreen1> {
  final VideoController videoController = VideoController();
  String? _selectedVideoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        backgroundColor: colorBackground,
      ),
      backgroundColor: colorBackground2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
              );
              if (result != null && result.files.isNotEmpty) {
                final selectedFile = result.files.single;
                if (selectedFile.path != null) {
                  print('Selected File Path: ${selectedFile.path}');
                  setState(() {
                    _selectedVideoPath = selectedFile.path;
                  });

                  // Chuyển hướng đến màn hình hiển thị video
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(videoPath: _selectedVideoPath!),
                    ),
                  );
                } else {
                  print('Error: selectedFile.path is null.');
                }
              }
            },
            child: const Text('Chọn và Hiển thị Video'),
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
                  setState(() {
                    _selectedVideoPath = selectedFile.path;
                  });
                } else {
                  print('Error: selectedFile.path is null.');
                }
              }
            },
            child: const Text('Chọn và Upload Video'),
          ),
          if (_selectedVideoPath != null)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoPlayerScreen(videoPath: _selectedVideoPath!),
                  ),
                );
              },
              child: const Text('Hiển thị Video'),
            ),
        ],
      ),
    );
  }
}
