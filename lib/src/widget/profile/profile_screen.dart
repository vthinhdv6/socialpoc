import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/common/widget/buttonCommonWidget.dart';
import 'package:socialpoc/common/widget/tab_bar_widget.dart';
import 'package:socialpoc/src/model/UserModel.dart';
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

class TikTokProfileScreen extends StatefulWidget {
  TikTokProfileScreen({super.key});

  @override
  State<TikTokProfileScreen> createState() => _TikTokProfileScreenState();
}

class _TikTokProfileScreenState extends State<TikTokProfileScreen> {
  final VideoController videoController = Get.put(VideoController());
  late UserModel userCurrent;
  final PageController pageController = PageController();
  TextEditingController textEditingControllerUsername = TextEditingController();
  bool isEditingName = false;

  Future<UserModel> fetchUserInformation() async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot documentSnapshot =
        await usersCollection.doc(FirebaseAuth.instance.currentUser?.uid).get();
    print(FirebaseAuth.instance.currentUser?.uid);
    if (documentSnapshot.data() != null) {
      Map<String, dynamic> jsonDecodeUser = documentSnapshot.data() as Map<String, dynamic>;
      print(jsonDecodeUser);

      userCurrent = UserModel.fromMap(jsonDecodeUser);
      print("user ${userCurrent.userName}");
      return userCurrent;
    }
    return userCurrent;
  }

  Future<void> changeUserInformation(bool optionChange, String contentChange) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot documentSnapshot =
        await userCollection.doc(FirebaseAuth.instance.currentUser?.uid).get();
    if (documentSnapshot.data() != null) {
      if (optionChange) {
        documentSnapshot.reference.update({
          'userName': contentChange,
        });
        setState(() {
          textEditingControllerUsername.text = '';
          isEditingName = false;
        });
      } else {
        documentSnapshot.reference.update({
          'avatarUrl': contentChange,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colorBackground2,
        appBar: AppBar(
          leading: const Icon(Icons.person),
          backgroundColor: colorBackground,
        ),
        body: FutureBuilder<UserModel>(
            future: fetchUserInformation(),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (snapshot.hasData) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Stack(children: [
                    const SizedBox(height: paddingDefault),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(userCurrent.avatarUrl),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: double.infinity,
                        height: 100.0,
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );
                              if (result != null && result.files.isNotEmpty) {
                                final selectedFile = result.files.single;
                                if (selectedFile.path != null) {
                                  print('Selected Image Path: ${selectedFile.path}');
                                  File imageFile = File(selectedFile.path!);
                                  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                                  print("usercr" + userId);
                                  await videoController.uploadAvatar(imageFile, userId);
                                } else {
                                  print('Error: selectedFile.path is null.');
                                }
                              }
                            },
                            child: const Icon(Icons.access_time_filled),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  // FutureBuilder<String?>(
                  //   future:
                  //       videoController.getUserName(FirebaseAuth.instance.currentUser?.uid ?? ''),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       // Nếu đang đợi dữ liệu, hiển thị một widget loading hoặc placeholder
                  //       return const CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       // Nếu có lỗi khi lấy dữ liệu, hiển thị một thông báo lỗi
                  //       return Text('Error: ${snapshot.error}');
                  //     } else {
                  //       // Nếu thành công, hiển thị tên người dùng từ Firebase
                  //       return Text(
                  //         snapshot.data ?? '', // Nếu dữ liệu null, sử dụng giá trị mặc định
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(fontWeight: FontWeight.w600, color: colorText2),
                  //       );
                  //     }
                  //   },
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isEditingName
                          ? SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              child: TextField(
                                controller: textEditingControllerUsername,
                                decoration: const InputDecoration(
                                  hintText: 'Type something...',
                                  // You can customize the appearance of the text field using various properties of InputDecoration
                                ),
                              ),
                            )
                          : Text(
                              snapshot.data!.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: textSizeMedium * 1.2,
                                color: colorBorder,
                              ),
                            ),
                      const SizedBox(
                        width: 3,
                      ),
                      isEditingName
                          ? InkWell(
                              onTap: () {
                                textEditingControllerUsername.text != ''
                                    ? changeUserInformation(
                                        true, textEditingControllerUsername.text)
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Validation'),
                                            content: const Text(
                                                "You haven't entered the specified content"),
                                            actions: <Widget>[
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                                ),
                                                child: const Text('I understand'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                              },
                              child: const Icon(Icons.save_alt),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditingName = true;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(75),
                                      border: Border.all(width: 1, color: Colors.black)),
                                  child: const Icon(Icons.mode_edit_outlined)),
                            )
                    ],
                  ),
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
                      borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
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
                    tabViewWidget: const [Text("trang 1"), Text("trang 2"), Text('trang 3')],
                    textTitle: const ['1', '2', '3'],
                    pageController: pageController,
                    unselectLabelBackground: Colors.white,
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
                                    margin: const EdgeInsets.symmetric(horizontal: 0.7),
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
                    child: const Text('Chọn và Upload Video'),
                  ),
                ]);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('nullValue');
              }
            }),
      ),
    );
  }
}
