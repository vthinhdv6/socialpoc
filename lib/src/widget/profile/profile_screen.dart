import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/common/helpdesk/help_deshk_function.dart';
import 'package:socialpoc/common/widget/buttonCommonWidget.dart';
import 'package:socialpoc/common/widget/tab_bar_widget.dart';
import 'package:socialpoc/data/model/fake_data_fire_base.dart';
import 'package:socialpoc/src/model/UserModel.dart';
import 'package:socialpoc/src/widget/list_of_following/list_of_following.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../model/ChatModel.dart';
import '../list-notification/chat_controller.dart';
import '../upvideo.dart';
import 'profile_controller.dart';

class Profile extends StatelessWidget {
  const Profile({this.userId = "current", super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TikTokProfileScreen(
        uIdUserFirebase: userId,
      ),
    );
  }
}

class TikTokProfileScreen extends StatefulWidget {
  const TikTokProfileScreen({
    super.key,
    required this.uIdUserFirebase,
  });

  final String uIdUserFirebase;

  @override
  State<TikTokProfileScreen> createState() => _TikTokProfileScreenState();
}

class _TikTokProfileScreenState extends State<TikTokProfileScreen> {
  late UserModel userCurrent;
  late String uIdUserProfile;
  final PageController pageController = PageController();
  TextEditingController textEditingControllerUsername = TextEditingController();
  bool isEditingName = false;
  late VideoController videoController;
  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController());
    }
    fetchUserInformation();
    chatController = Get.find<ChatController>();
    videoController = Get.put(VideoController(
        widget.uIdUserFirebase.contains('current')
            ? FirebaseAuth.instance.currentUser!.uid
            : widget.uIdUserFirebase));
  }

  Future<UserModel> fetchUserInformation() async {
    print("debug user firsr ${widget.uIdUserFirebase}");
    widget.uIdUserFirebase == 'current'
        ? uIdUserProfile = FirebaseAuth.instance.currentUser!.uid
        : uIdUserProfile = widget.uIdUserFirebase;
    userCurrent = generateFakeUser();
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot documentSnapshot =
        await usersCollection.doc(uIdUserProfile).get();
    if (documentSnapshot.data() != null) {
      Map<String, dynamic> jsonDecodeUser =
          documentSnapshot.data() as Map<String, dynamic>;
      userCurrent = UserModel.fromMap(jsonDecodeUser);
      return userCurrent;
    }
    return userCurrent;
  }

  Future<void> changeUserInformation(
      bool optionChange, String contentChange) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
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
    chatController = Get.find<ChatController>();
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
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(children: [
                        const SizedBox(height: paddingDefault),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundImage:
                                NetworkImage(userCurrent.avatarUrl),
                          ),
                        ),
                        uIdUserProfile.contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? Positioned(
                                child: Container(
                                  width: double.infinity,
                                  height: 100.0,
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    width: 30.0,
                                    height: 30.0,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.image,
                                        );
                                        if (result != null &&
                                            result.files.isNotEmpty) {
                                          final selectedFile =
                                              result.files.single;
                                          if (selectedFile.path != null) {
                                            File imageFile =
                                                File(selectedFile.path!);
                                            String userId = FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    ?.uid ??
                                                '';
                                            await videoController.uploadAvatar(
                                                imageFile, userId);
                                            setState(() {});
                                          } else {}
                                        }
                                      },
                                      child: const Icon(Icons.camera),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ]),
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
                                        ? changeUserInformation(true,
                                            textEditingControllerUsername.text)
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
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child: const Text(
                                                        'I understand'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                  },
                                  child: const Icon(Icons.save_alt),
                                )
                              : uIdUserProfile.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isEditingName = true;
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(75),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black)),
                                          child: const Icon(
                                              Icons.mode_edit_outlined)),
                                    )
                                  : SizedBox(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: changeToListFollow,
                                child: Text(
                                  '${userCurrent.followers.length - 1} \nĐang follow',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: InkWell(
                                onTap: changeToListFollow,
                                child: Text(
                                  '${userCurrent.following.length - 1}\nFollow',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: paddingDefault),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40)),
                            color: Colors.white,
                          ),
                          child: uIdUserProfile.contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ButtonCommonWidget(
                                      buttonText: 'Thông báo',
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
                                )
                              : FutureBuilder<bool>(
                                  future: isFollowUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      'yAQdk28qRNDfxYMaeN1s'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        child: snapshot.data!
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    // onPressed: () {
                                                    //   followUserToFirebase(
                                                    //       // FirebaseAuth.instance.currentUser!.email, userModel!.email);
                                                    // },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      followUserToFirebase;
                                                      setState(() {});
                                                    },
                                                    child: const Text(
                                                      'Unfollow',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  ElevatedButton(
                                                    // onPressed: () {
                                                    //   followUserToFirebase(
                                                    //       // FirebaseAuth.instance.currentUser!.email, userModel!.email);
                                                    // },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Send message',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Xử lý khi nút "Follow" được nhấn
                                                      followUserToFirebase(
                                                        FirebaseAuth.instance
                                                            .currentUser?.email,
                                                        userCurrent.email,
                                                      );
                                                      setState(() {});
                                                    },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Colors.red),
                                                    ),
                                                    child: const Text(
                                                      'Follow',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      String currentUserId =
                                                          FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid ??
                                                              '';
                                                      String otherUserId =
                                                          widget
                                                              .uIdUserFirebase;
                                                      ChatModel? existingChat =
                                                          chatController
                                                              .chatList
                                                              .firstWhereOrNull(
                                                        (chat) =>
                                                            chat.userIds.contains(
                                                                currentUserId) &&
                                                            chat.userIds.contains(
                                                                otherUserId) &&
                                                            chat.userIds
                                                                    .length ==
                                                                2,
                                                      );
                                                      if (existingChat !=
                                                          null) {
                                                        await chatController
                                                            .navigateToChat(
                                                                existingChat);
                                                      } else {
                                                        List<String> userIds = [
                                                          currentUserId,
                                                          otherUserId
                                                        ];
                                                        await chatController
                                                            .createChat(
                                                                userIds);

                                                        // Fetch the updated chat list
                                                        await chatController
                                                            .fetchChatsFromFirebase();

                                                        ChatModel newChat =
                                                            chatController
                                                                .chatList
                                                                .firstWhere(
                                                          (chat) =>
                                                              chat.userIds.contains(
                                                                  currentUserId) &&
                                                              chat.userIds
                                                                  .contains(
                                                                      otherUserId),
                                                        );

                                                        await chatController
                                                            .navigateToChat(
                                                                newChat);
                                                      }
                                                      setState(() {});
                                                    },
                                                    style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Colors.grey),
                                                    ),
                                                    child: const Text(
                                                      'Nhắn Tin',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                )),
                      const Divider(
                        color: colorBackground2,
                        height: 1,
                      ),
                      TabBarWidget(
                        tabViewWidget:  [
                          Expanded(
                            child: PageView(
                              controller: pageController,
                              children: [
                                // Page 1: User's videos
                                SizedBox(
                                  height: 200.0,
                                  child: Container(
                                    height: 150.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: videoController.videos.length,
                                      itemBuilder: (context, index) {
                                        final video = videoController.videos[index];
                                        print("Video User ID: ${video.user}");
                                        print("Current User ID: ${userCurrent}");

                                        if (video.user == userCurrent) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width / 3 - 3,
                                            margin: const EdgeInsets.symmetric(horizontal: 0.7),
                                            child: Chewie(
                                              controller: ChewieController(
                                                videoPlayerController: VideoPlayerController.network(
                                                  video.url,
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
                                // Add more pages if needed
                              ],
                            ),

                          ),

                          Text("trang 2"),
                          Text('trang 3')
                        ],
                        textTitle: const ['1', '2', '3'],
                        pageController: pageController,
                        unselectLabelBackground: Colors.white,
                      ),
                    ]);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  void changeToListFollow() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactInformationIntime(
                  userCurrentModel: userCurrent,
                  numberCountFollowers: userCurrent.followers.length - 1,
                )));
  }
}
