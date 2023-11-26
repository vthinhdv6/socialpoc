import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../firebase/firestoreservice.dart';

import '../model/videoModel.dart';
import 'home_controller.dart';
import 'profile/profile_controller.dart';
import 'package:get/get.dart';

import 'profile/profile_screen.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              const VideoListWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Following',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 20,
                            width: 3,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'For you',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({super.key});

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget>
    with AutomaticKeepAliveClientMixin {
  final FirestoreService firestoreService = FirestoreService();
  late Future<List<VideoModel>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = firestoreService.getVideos();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: futureVideos,
          builder: (context, AsyncSnapshot<List<VideoModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            List<VideoModel> videos = snapshot.data!;
            return CarouselSlider.builder(
              itemCount: videos.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: VideoPlayerWidget(
                  videoUrl: videos[itemIndex].url,
                  videos: videos,
                  // Pass the videos list to VideoPlayerWidget
                  currentIndex: itemIndex, // Pass the current index
                ),
              ),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.vertical,
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoController videoController = Get.put(VideoController());
  final String videoUrl;
  final List<VideoModel> videos;
  final int currentIndex;

  VideoPlayerWidget(
      {Key? key,
      required this.videoUrl,
      required this.videos,
      required this.currentIndex})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  final VideoController videoController = Get.put(VideoController());
  final HomeController homeController = Get.put(HomeController());
  bool isVideoPlaying = true;
  bool isLiked = false;
  int currentVideoIndex = 2;
  List<VideoModel>? videos;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
        if (!_controller.value.isInitialized) {
          print('Video initialization failed.');
        }
      });
  }

  void _onPlayPause() {
    if (isVideoPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      isVideoPlaying = !isVideoPlaying;
    });
  }

  void _onLike() async {
    String userId = homeController.getCurrentUserId();

    if (widget.currentIndex >= 0 && widget.currentIndex < widget.videos.length) {
      VideoModel videoModel = widget.videos[widget.currentIndex];

      if (homeController != null) {
        bool isUserLiked = homeController.isLiked.value;

        if (isUserLiked) {
          // Unlike the video
          videoModel.likes = (videoModel.likes ?? 0) - 1;
        } else {
          // Like the video
          videoModel.likes = (videoModel.likes ?? 0) + 1;
        }

        // Update the isLiked state
        setState(() {
          isLiked = !isUserLiked;
        });

        // Update the like count in the Firestore database
        await FirebaseFirestore.instance
            .collection('videos')
            .doc(videoModel.videoId)
            .update({
          'likes': videoModel.likes,
        });

        homeController.toggleLike(videoModel, userId);
      } else {
        print('Error: homeController is null');
      }
    } else {
      print('Error: Invalid index or video list');
    }
  }


  void _onComment() {
    // Handle comment button press
  }

  void _onShare() {
    // Handle share button press
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _controller.value.isInitialized
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: _onPlayPause,
                  child: Positioned(
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  ),
                ),
                !isVideoPlaying
                    ? const Positioned(
                        child: Center(
                          child: Icon(
                            Icons.not_started_rounded,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()),
                            );
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.red,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage:
                                      NetworkImage(videoController.avatarUrl),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _onLike,
                          icon: Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.red : Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.videos[widget.currentIndex].likes ?? 0}',
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: _onComment,
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: _onShare,
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const CircularProgressIndicator();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
