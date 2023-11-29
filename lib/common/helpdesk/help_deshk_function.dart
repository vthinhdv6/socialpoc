import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socialpoc/data/model/fake_data_fire_base.dart';
import 'package:socialpoc/src/model/UserModel.dart';

Future<void> followUserToFirebase(String? emailUserFollow, String? emailUserFollowed) async {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshotFollow =
      await userCollection.where('email', isEqualTo: emailUserFollow).get();
  QuerySnapshot querySnapshotFollowed =
      await userCollection.where('email', isEqualTo: emailUserFollowed).get();
  String userFollowId = querySnapshotFollow.docs.first.id;
  String userFollowedId =querySnapshotFollowed.docs.first.id;
  print(userFollowId+userFollowedId);
  if (querySnapshotFollow.docs.isNotEmpty && querySnapshotFollowed.docs.isNotEmpty) {
    UserModel userModelFollow = await fetchUserInformation(userFollowId);
    UserModel userModelFollowed = await fetchUserInformation(userFollowedId);
    if (userModelFollowed.followers.contains(userFollowId)) {
      print("remoe friend");
      userModelFollowed.followers.remove(userFollowId);
      userModelFollow.following.remove(userFollowedId);
      querySnapshotFollowed.docs.first.reference.update({
        'followers': userModelFollowed.followers,
      });
      querySnapshotFollow.docs.first.reference.update({
        'following': userModelFollow.following,
      });
      print("alreadyremove");

    } else {
      userModelFollowed.followers.add(userFollowId);
      userModelFollow.following.add(userFollowedId);
      querySnapshotFollowed.docs.first.reference.update({
        'followers': userModelFollowed.followers,
      });
      querySnapshotFollow.docs.first.reference.update({
        'following': userModelFollow.following,
      });
    }
  }
}

Future<String> findUid(String emailUser) async {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshot = await userCollection.where('email', isEqualTo: emailUser).get();
  if (querySnapshot.docs.isNotEmpty) {
    return userCollection.id;
  }
  return 'null';
}

Future<bool> checkFriend(String userCheck, String userChecked) async {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final DocumentSnapshot documentSnapshotFollower = await usersCollection.doc(userChecked).get();
  dynamic stringFollow = documentSnapshotFollower.data() as Map<String, dynamic>;
  print("step1");
  List<String>? listFollowing = List<String>.from(stringFollow['following']);
  if (listFollowing.contains(userCheck)) {
    print("true");
    return true;
  }
  print('false');
  return false;
}

Future<UserModel> fetchUserInformation(String uId) async {
  late final UserModel userModel;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final DocumentSnapshot documentSnapshot = await usersCollection.doc(uId).get();
  if (documentSnapshot.data() != null) {
    Map<String, dynamic> jsonDecodeUser = documentSnapshot.data() as Map<String, dynamic>;
    userModel = UserModel.fromMap(jsonDecodeUser);
    return userModel;
  }
  return userModel = generateFakeUser();
}
