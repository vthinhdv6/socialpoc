import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../firebase/firestoreservice.dart';
import '../model/video.dart';

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dành cho bạn'),
      ),
      body: VideoListWidget(),
    );
  }
}

class VideoListWidget extends StatefulWidget {
  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget>
    with AutomaticKeepAliveClientMixin {
  final FirestoreService firestoreService = FirestoreService();

  @override
  bool get wantKeepAlive => true;

  List<VideoModel>? videos;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: firestoreService.getVideos(),
      builder: (context, AsyncSnapshot<List<VideoModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        videos = snapshot.data;

        return ListView.builder(
          itemCount: videos!.length,
          itemBuilder: (context, index) {
            return VideoPlayerWidget(videoUrl: videos![index].url);
          },
        );
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool isVideoPlaying = false;

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
        ? Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.all(8.0),
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
                IconButton(
                  onPressed: _onPlayPause,
                  icon: Icon(
                    isVideoPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút tim
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút comment
                  },
                  icon: Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút share
                  },
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        : CircularProgressIndicator();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
