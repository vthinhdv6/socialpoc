import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialpoc/src/model/CommentModel.dart';

import '../model/UserModel.dart';
import '../model/videoModel.dart';
import '../widget/home.dart';
import '../widget/list-notification/notification.dart';
import 'comment_controller.dart';

class CommentScreen extends StatefulWidget {
  final VideoModel video;
  final String avatarUrl;
  final String userId;

  CommentScreen({required this.video, required this.avatarUrl, required this.userId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CommentController commentController = Get.put(CommentController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Player Section
          VideoPlayerWidget(
            videoUrl: widget.video.url,
            videos: [widget.video],
            avatarUrl: widget.avatarUrl,
            currentIndex: 0,
            video: widget.video,
            userId: widget.userId,
          ),
          // Comments Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Comment List
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .where('videoId', isEqualTo: widget.video.videoId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          var comments = (snapshot.data! as QuerySnapshot)
                              .docs
                              .map(
                                  (doc) => CommentModel.fromMap(doc.data() as Map<String, dynamic>))
                              .toList();

                          if (comments.isNotEmpty) {
                            return CommentList(
                                video: widget.video,
                                comments: comments,
                                scrollController: _scrollController);
                          } else {
                            return Center(child: Text("No comments yet."));
                          }
                        }

                        // If there's no data yet or still loading
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  // Comment Input Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Thêm bình luận...',
                            ),
                            autofocus: true,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Handle comment submission here
                            String commentText = _commentController.text;

                            if (commentText.isNotEmpty) {
                              String currentUserId = FirebaseAuth.instance.currentUser!.uid;
                              String uid =
                                  FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';

                              String commentId = uid;
                              showNotification('bình luận mới', 'bạn có bình luận mới từ video của bạn.');

                              DocumentReference commentRef =
                                  await FirebaseFirestore.instance.collection('comments').add({
                                'commentId': commentId,
                                'videoId': widget.video.videoId,
                                'userId': currentUserId, // Replace with actual user ID
                                'content': commentText,
                                'commentTime': DateTime.now().toUtc(),
                              });

                              setState(() {
                                _commentController.clear();
                                _scrollController
                                    .jumpTo(_scrollController.position.maxScrollExtent);
                              });
                            }
                          },
                          child: Text('Bình luận'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final VideoModel video;
  final List<CommentModel> comments;
  final ScrollController scrollController;
  final CommentController chatController = Get.find<CommentController>();

  CommentList({
    required this.video,
    required this.comments,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        CommentModel comment = comments[index];

        return FutureBuilder(
          future: chatController.getUserInfo(comment.userId),
          builder: (context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              UserModel? user = snapshot.data;

              return CommentItem(
                avatarUrl: user?.avatarUrl ?? '',
                username: user?.userName ?? 'Unknown User',
                content: comment.content,
                time: comment.commentTime,
              );
            }
          },
        );
      },
    );
  }
}

class CommentItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String content;
  final DateTime time;

  CommentItem({
    required this.avatarUrl,
    required this.username,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                content,
                style: TextStyle(fontSize: 15.0),
              ),
              Text(
                time.toString(), // You might want to format this as needed
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
