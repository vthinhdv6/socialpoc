import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Register1231 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FirestoreExample(),
    );
  }
}
class FirestoreExample extends StatefulWidget {
  @override
  _FirestoreExampleState createState() => _FirestoreExampleState();
}

class _FirestoreExampleState extends State<FirestoreExample> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    try {
      await usersCollection.doc('exampleUserId1').set({
        'userId': 'exampleUserId1',
        'followers': [],
        'following': [],
        'age': 20,
        'videos': [],
        'likedVideos': [],
      });
      print("User added to Firestore");
    } catch (error) {
      print("Error adding user to Firestore: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addUser,
          child: Text('Add User to Firestore'),
        ),
      ),
    );
  }
}