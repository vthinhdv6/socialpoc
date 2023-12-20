import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialpoc/src/widget/login/login_screen.dart';
import 'package:socialpoc/src/widget/list-notification/notification.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';



void main() async {
  initializeNotifications();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreenMainApp(),
    );
  }
}