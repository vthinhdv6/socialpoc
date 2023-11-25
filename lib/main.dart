import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialpoc/src/widget/login/login_email_screen.dart';


import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


import 'src/widget/home.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(MainScreen ());
}

