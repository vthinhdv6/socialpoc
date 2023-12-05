import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialpoc/common/helpdesk/help_deshk_function.dart';
import 'package:socialpoc/src/model/UserModel.dart';
import 'package:socialpoc/src/widget/list_of_following/components/card_follow.dart';

class ListOfFollowing extends StatefulWidget {
  const ListOfFollowing({super.key, required this.userCurrentModel});
  final UserModel userCurrentModel;
  @override
  State<ListOfFollowing> createState() => _ListOfFollowingState();
}

class _ListOfFollowingState extends State<ListOfFollowing> {
  final TextEditingController _textEditingController = TextEditingController();
  Future<List<String>> fetchFollower() async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot documentSnapshotFollower =
        await usersCollection.doc(FirebaseAuth.instance.currentUser?.uid).get();
    dynamic stringFollow = documentSnapshotFollower.data() as Map<String, dynamic>;
    List<String>? listFollowing = List<String>.from(stringFollow['following']);
    return listFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder<List<String>>(
            future: fetchFollower(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: const Text('Validation'),
                  content: Text(snapshot.error.toString()),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('I understand yes'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              } else {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: TextFormField(
                              controller: _textEditingController,
                              autofocus: true,
                              obscureText: false,
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search_sharp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: snapshot.data!.map((item) {
                            return !item.contains('null')
                                ? FutureBuilder<UserModel>(
                                    future: fetchUserInformation(item),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return AlertDialog(
                                          title: const Text('Validation'),
                                          content: Text("${snapshot.error}2"),
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
                                      } else if (snapshot.data!.userName != 'default' ||
                                          snapshot.data != null) {
                                        return CardFollower(
                                          userModel: snapshot.data,
                                          uId: item,
                                          contextOld: context,
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    })
                                : const SizedBox();
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
