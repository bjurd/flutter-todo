import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:todo/welcome.dart';
import 'package:todo/signup.dart';
import 'package:todo/login.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    initialRoute: "/",

    routes:
    {
      "/": (context) => Welcome(),
      "/signup": (context) => SignUp(),
      "/login": (context) => Login()
    }
  ));
}
