import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/src/model/UserModel.dart';
import 'package:socialpoc/src/widget/list_of_following/tab_bar_list_follower.dart';
import 'package:socialpoc/src/widget/list_of_following/tab_bar_list_following.dart';

class ContactInformationIntime extends StatefulWidget {
  const ContactInformationIntime({super.key, required this.userCurrentModel, required this.numberCountFollowers});
  final  UserModel userCurrentModel;
  final  int numberCountFollowers;

  @override
  State<ContactInformationIntime> createState() => _ContactInformationIntimeState();
}

class _ContactInformationIntimeState extends State<ContactInformationIntime> {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
        child : Scaffold(
          appBar: AppBar(
            backgroundColor: colorBackground2,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Followers ${widget.numberCountFollowers}',),
                Tab(text: 'Following ${widget.userCurrentModel.following.length - 1}'),
                Tab(text: 'Friend'),
              ],
            ),
            title: Text('Tabs Demo'),
            centerTitle: true,

          ),
          body: TabBarView(
            children: [
              ListOfFollowers(userCurrentModel:widget.userCurrentModel),
              ListOfFollowing(userCurrentModel:widget.userCurrentModel),
              Icon(Icons.directions_car, size: 350),
            ],
          ),
        ),
      );
  }
}
