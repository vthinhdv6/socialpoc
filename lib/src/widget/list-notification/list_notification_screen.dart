import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/data/model/fake_data_fire_base.dart';
import 'package:socialpoc/data/model/notification_model.dart';
import 'package:socialpoc/data/model/tym_view_model.dart';
import 'package:socialpoc/data/model/user_view_model.dart';
import 'package:socialpoc/src/model/UserModel.dart';
import 'package:socialpoc/src/widget/list-notification/notification_widget.dart';
import 'package:socialpoc/src/widget/login/register_screen.dart';

class ListNotificationScreen extends StatefulWidget {
  const ListNotificationScreen({super.key});
  @override
  State<ListNotificationScreen> createState() => _ListNotificationScreenState();
}

class _ListNotificationScreenState extends State<ListNotificationScreen> {
  List<NotificationModel>? listNotification;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userViewModel;
  TymVideo? tymVideo;
  @override
  void initState() {
    listNotification = List.generate(5, (index) {
      return NotificationModel(
        'Notification Title ${index + 1}',
        'https://th.bing.com/th/id/OIP.0Qtq5yexJpyOdN8Dqyh14AHaHa?w=600&h=600&rs=1&pid=ImgDetMain',
        'Notification subtitle ${index + 1}',
        Icons.notifications,
      );
    });
    tymVideo = fakeDataTymVideo()[0];
    userViewModel = generateFakeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBackground2,
          title: const Text('Your information'),
          centerTitle: true,
          leading: const Icon(Icons.add_circle),
          actions: const [
            Icon(Icons.search),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listNotification?.length,
                itemBuilder: (context, index) {
                  return NotificationWidget(notification: listNotification![index]);
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    followUserToFirebase('etQqxTiQR3qnXaY8usv0', 'qpizAFNUMbAAlJs3u2LZ');
                  },
                  child: Icon(Icons.transit_enterexit)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pushUserToFirebase(UserModel user) async {
    try {
      final documentReference = FirebaseFirestore.instance.collection('users').doc();
      await firestore.collection('users').add({
        'userId': documentReference.id,
        'username': user.userName,
        'avatarUrl': user.avatarUrl,
        'followers': user.followers,
        'following': user.following,
        'videos': user.videos,
        'likedVideos': user.likedVideos,
        'age': user.age,
        'email': user.email,
      });
      print('User pushed to Firebase successfully');
    } catch (error) {
      print('Error pushing User to Firebase: $error');
    }
  }

  Future<void> pushTymVideoToFirebase(TymVideo tymVideo) async {
    try {
      await firestore.collection('tymVideo').add({
        'idUser': tymVideo.idUser,
        'idVideo': tymVideo.idVideo,
      });
      print('TymVideo pushed to Firebase successfully');
    } catch (error) {
      print('Error pushing TymVideo to Firebase: $error');
    }
  }

  Future<void> followUserToFirebase(String idUserFollow, String idUserFollowing) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('userId', isEqualTo: idUserFollow).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDocument = querySnapshot.docs.first;
      dynamic stringFollow = userDocument.data() as Map<String, dynamic>;
      List<String>? followerUsers = List<String>.from(stringFollow['followers']);
      print(followerUsers.length);
      if (!followerUsers.contains(idUserFollowing)) {
        followerUsers?.add(idUserFollowing);
        userDocument.reference.update({
          'followers': followerUsers,
        });
        print('da them fler');
        QuerySnapshot querySnapshotFollowing =
            await userCollection.where('userId', isEqualTo: idUserFollowing).get();
        if (querySnapshotFollowing.docs.isNotEmpty) {
          DocumentSnapshot userDocument = querySnapshotFollowing.docs.first;
          dynamic stringFollow = userDocument.data() as Map<String, dynamic>;
          List<String>? followingUsers = List<String>.from(stringFollow['following']);
          followingUsers?.add(idUserFollowing);
          userDocument.reference.update({
            'following': followingUsers,
          });
          print('da them flwing');
        }
      }
    }
  }
}
