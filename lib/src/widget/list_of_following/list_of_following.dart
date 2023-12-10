import 'package:flutter/material.dart';
import 'package:socialpoc/common/contants.dart';
import 'package:socialpoc/src/model/UserModel.dart';
import 'package:socialpoc/src/widget/list_of_following/tab_bar_list_follower.dart';
import 'package:socialpoc/src/widget/list_of_following/tab_bar_list_following.dart';
import 'package:socialpoc/src/widget/login/login_email.dart';

class ContactInformationIntime extends StatefulWidget {
  const ContactInformationIntime(
      {super.key, required this.userCurrentModel, required this.numberCountFollowers});
  final UserModel userCurrentModel;
  final int numberCountFollowers;

  @override
  State<ContactInformationIntime> createState() => _ContactInformationIntimeState();
}

class _ContactInformationIntimeState extends State<ContactInformationIntime>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBackground2,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: 'Followers ${widget.numberCountFollowers}',
              ),
              Tab(text: 'Following ${widget.userCurrentModel.following.length - 1}'),
              const Tab(text: 'Friend'),
            ],
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ListOfFollowers(userCurrentModel: widget.userCurrentModel),
            ListOfFollowing(userCurrentModel: widget.userCurrentModel),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreenMain(),
                    ),
                  );
                },
                child: const Text("press")),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
