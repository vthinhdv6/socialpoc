import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addvideo/uploadvidep_screen.dart';
import 'home.dart';
import 'list-notification/chat_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeTab(),
    ProfileTab(),
    TrashTab(),
    InboxTab(), // Thêm InboxTab
    AddTab(),   // Thêm AddTab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Trash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Inbox', // Thêm item cho InboxTab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add', // Thêm item cho AddTab
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: VideoScreen(),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId=  'df';
    print(userId);
    if (userId != null) {
      print('debug + $userId');
      return const Center(
        child: Profile(),
      );
    } else {
      return const Center(
        child: Text('User not logged in'),
      );
    }
  }
}

class TrashTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Trash Tab'),
    );
  }
}

class InboxTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChatScreenBody(),
    );
  }
}

class AddTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TikTokProfileScreen2(),
    );
  }
}
