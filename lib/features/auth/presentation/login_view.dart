import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_333/core/managers/firebase_error_validation.dart';
import 'package:flutter_333/features/admin_pages/views/LocalSignUpRequestsPage.dart';
import 'package:flutter_333/features/auth/presentation/forgot_password_view.dart';
import 'package:flutter_333/features/auth/presentation/sign_up_view.dart';
import 'package:flutter_333/features/experience/main_experience_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (email == "admin@example.com" && password == "Admin1234") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Adminpages()),
        );
        return;
      }

      final res = await FirebaseFirestore.instance
          .collection('local_sign_up_requests')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      final res2 = await FirebaseFirestore.instance
          .collection('tourist')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      log(" ::: ::: Local res: ${res.data()}");
      log(" ::: ::: tourist res: ${res2.data()}");

      if (res2.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainExperienceScreen(
              type: 'tourist',
            ),
          ),
        );
      } else if (res.exists && res.data()?['status'] == 'approved') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainExperienceScreen(
                    type: 'local',
                  )),
        );
      } else if (res.exists && res.data()?['status'] == 'pending') {
        _showErrorDialog(
            'Pending Request', 'Your request is still under review.');
      } else if (res.exists && res.data()?['status'] == 'rejected') {
        _showErrorDialog('Rejected Request', 'Your request has been rejected.');
      } else {
        _showErrorDialog(
            'Access Denied', 'You are neither a local nor a tourist.');
      }
    } on FirebaseAuthException catch (e) {
      final error = FirebaseErrorValidation.getErrorMessageFromCode(e.code);

      _showErrorDialog('', error);
    } catch (e) {
      _showErrorDialog('Error', 'An error occurred: ${e.toString()}');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/icons/welcome.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'WELCOME!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '!يالله حيُّهم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: isObscure,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: Icon(isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter password' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordView()),
                    );
                  },
                  child: const Text('Forgot Password?',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) _login();
                },
                child: const Text('Log In',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign Up as a Local',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => SignUpScreen(
                                        type: 'local',
                                      )));
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign Up as a Tourist',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => SignUpScreen(
                                        type: 'tourist',
                                      )));
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
