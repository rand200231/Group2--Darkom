import 'package:flutter/material.dart';
import 'package:flutter_333/features/auth/presentation/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_333/features/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/experience/main_experience_screen.dart';
import 'features/home/screens/tourist_home_screen.dart';
import 'payment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'poppins').copyWith(
        primaryColor: const Color(0xFFA5814F),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!),
          ),
          labelStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          filled: false,
          contentPadding: EdgeInsets.only(bottom: 8),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFab875f)),
        textTheme: GoogleFonts.blinkerTextTheme(),
      ),
      home: MainExperienceScreen(type: 'tourist',),
      // home: LoginScreen(),
      // home: PAymentScreen(),
    );
  }
}
