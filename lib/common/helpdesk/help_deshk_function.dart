import 'package:cloud_firestore/cloud_firestore.dart';
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

Future<bool> isFollowUser(String userCheck,String userChecked) async {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final DocumentSnapshot documentSnapshotFollower = await usersCollection.doc(userCheck).get();
  dynamic stringFollow = documentSnapshotFollower.data() as Map<String, dynamic>;
  List<String>? listFollowing = List<String>.from(stringFollow['following']);
  if (listFollowing.contains(userChecked)) {
    print("true");
    return true;
  }
  else{
    return false;
  }

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

Future<String> unFollow(String uIdUserCurrent, String uIdUserFollowed) async{
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot documentSnapshotFollower = await usersCollection.doc(uIdUserCurrent).get();
  dynamic stringFollow = documentSnapshotFollower.data() as Map<String, dynamic>;
  List<String>? listFollowing = List<String>.from(stringFollow['following']);
  if (listFollowing.contains(uIdUserFollowed)) {
    documentSnapshotFollower.reference.update({
      'following' :listFollowing.remove(uIdUserFollowed),
    });
    documentSnapshotFollower = await usersCollection.doc(uIdUserFollowed).get();
    stringFollow = documentSnapshotFollower.data() as Map<String, dynamic>;
    listFollowing = List<String>.from(stringFollow['follower']);
    if (listFollowing.contains(uIdUserCurrent)) {
      documentSnapshotFollower.reference.update({
        'follower': listFollowing.remove(uIdUserCurrent),
      });
      return "success";
    }
    return 'success in current un follow';

  }
  else{
    return 'fail';
  }
}


