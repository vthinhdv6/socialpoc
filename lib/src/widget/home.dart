import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../firebase/firestoreservice.dart';
import '../model/video.dart';

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

class _VideoListWidgetState extends State<VideoListWidget> with AutomaticKeepAliveClientMixin {
  final FirestoreService firestoreService = FirestoreService();
  @override
  void initState() {
    loadListVideoWidget();
    // TODO: implement initState
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
// list video khong thay doi
  List<VideoModel>? videos;
  List<Widget> videoWidgets = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: firestoreService.getVideos(),
          builder: (context, AsyncSnapshot<List<VideoModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            videos = snapshot.data;
            return CarouselSlider.builder(
                itemCount: videos!.length,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayerWidget(videoUrl: videos![itemIndex].url)),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  // autoPlay: true,
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.vertical,
                ));
          },
        ),
      ),
    );
  }

  Future<void> loadListVideoWidget() async {
    videos?.forEach((element) {
      videoWidgets.add(SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: VideoPlayerWidget(videoUrl: element.url)));
    });
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool isVideoPlaying = true;

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
                    scale: 1.5, // Điều chỉnh tỷ lệ gấp đôi
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(75)),
                          height: 50,
                          width: 50,
                          child: const Stack(
                            children: [
                              CircleAvatar(
                                radius: 23,
                                backgroundColor: Colors.red,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1597466765990-64ad1c35dafc'),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.white70,
                                  ))
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Xử lý sự kiện khi nhấn nút tim
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Xử lý sự kiện khi nhấn nút comment
                          },
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Xử lý sự kiện khi nhấn nút share
                          },
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
