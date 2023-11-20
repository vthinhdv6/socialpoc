import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/common/widget/buttonCommonWidget.dart';
import 'package:socialpoc/common/widget/tab_bar_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
  final PageController pageController = PageController();

  TikTokProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.person),
          backgroundColor: colorBackground,
        ),
        backgroundColor: colorBackground2,
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Column(
            children: [
              const SizedBox(height: paddingDefault),
               CircleAvatar(
                radius: 40.0,
                backgroundImage:
                    NetworkImage(videoController.avatarUrl),
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
              FutureBuilder<String?>(
                future: videoController.getUserName(FirebaseAuth.instance.currentUser?.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Nếu đang đợi dữ liệu, hiển thị một widget loading hoặc placeholder
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Nếu có lỗi khi lấy dữ liệu, hiển thị một thông báo lỗi
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Nếu thành công, hiển thị tên người dùng từ Firebase
                    return Text(
                      snapshot.data ?? '', // Nếu dữ liệu null, sử dụng giá trị mặc định
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, color: colorText2),
                    );
                  }
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: const Text(
                        '1\nĐang follow',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: const Text(
                        '4\nFollow',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: const Text(
                        '1\nYeu thich',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                ],
              ),
              const SizedBox(height: paddingDefault),
              Container(
                padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonCommonWidget(
                      buttonText: 'Sửa hồ sơ',
                      fontColor: colorText,
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      borderColor: colorText,
                    ),
                    ButtonCommonWidget(
                      buttonText: 'Chia sẻ hồ sơ',
                      onPressed: () {},
                      borderColor: Colors.transparent,
                    ),
                    ButtonCommonWidget(
                      buttonText: 'Follow +',
                      onPressed: () {},
                      borderColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: colorBackground2,
                height: 1,
              ),
              TabBarWidget(
                tabViewWidget: const [
                  Text("trang 1"),
                  Text("trang 2"),
                  Text('trang 3')
                ],
                textTitle: const ['1', '2', '3'],
                pageController: pageController,
                unselectLabelBackground: Colors.white,
              )
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
                                videoPlayerController:
                                    VideoPlayerController.network(
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
            child: const Text('Chọn và Upload Video'),
          ),
        ]));
  }
}
