import 'package:flutter/material.dart';
import '../screens/signUpTourist.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'signUpTourist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
        primaryColor: const Color(0xFFA5814F),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'poppins',
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
        // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF1ACB97)),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFab875f)),
        useMaterial3: true,
        
      ),
  home: const SignUpScreen(),
);
  }
}