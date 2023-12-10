import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialpoc/common/helpdesk/help_deshk_function.dart';
import 'package:socialpoc/src/model/UserModel.dart';
import 'package:socialpoc/src/widget/profile/profile_screen.dart';

class CardFollower extends StatelessWidget {
  const CardFollower({
    super.key,
    required this.userModel,
    required this.uId,
    required this.contextOld,

  });
  final BuildContext contextOld;
  final UserModel? userModel;
  final String uId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (contextOld) => TikTokProfileScreen(
              uIdUserFirebase: uId,
            ),
          ),
        );
      },
      child: FutureBuilder<bool>(
          future: checkFriend(uId, FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (contextOld) => TikTokProfileScreen(
                        uIdUserFirebase: uId,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userModel!.avatarUrl),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userModel!.userName,
                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                snapshot.data! ? userModel!.email : "Maybe you interesting",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 15),
                              ),
                            ],
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: snapshot.data!
                                ? ElevatedButton(
                                    onPressed: () {
                                      followUserToFirebase(
                                          FirebaseAuth.instance.currentUser!.email, userModel!.email);
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                    ),
                                    child: const Text(
                                      'Friend',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      followUserToFirebase(
                                          FirebaseAuth.instance.currentUser?.email, userModel!.email);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
