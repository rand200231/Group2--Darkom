/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_darkom/mypages/LocalSignUpRequestsPage.dart';
//import 'package:flutter_darkom/darkom.dart'; unused import
import 'package:flutter_darkom/firebase_options.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_darkom/mypages/login_screen.dart';
import 'package:flutter_darkom/mypages/forgot_password_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: LocalSignUpRequestsPage(),
      home: LoginScreen(),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_darkom/mypages/LocalSignUpRequestsPage.dart';
import 'package:flutter_darkom/mypages/login_screen.dart'; // Import the login screen
import 'package:flutter_darkom/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(), // Set the login screen as the home screen
    );
  }
}
