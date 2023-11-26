import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialpoc/src/widget/login/login_email_screen.dart';
import 'package:socialpoc/src/widget/login/register_email_screen.dart';
import 'package:socialpoc/src/widget/main_screen.dart';
import 'package:socialpoc/src/widget/profile/profile_screen.dart';

import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'src/widget/home.dart';
import 'src/widget/list-notification/list_notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(MainScreen());
}
