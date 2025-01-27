import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_view.dart';
import 'LocalSignUpRequestsPage.dart';
import 'forgot_password_screen.dart'; // Ensure this file exists
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "admin@example.com" && password == "admin1234") {
      // Admin login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LocalSignUpRequestsPage()),
      );
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Login failed')),
          );
        }
      }
    }
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
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
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
                      '\u064A\u0627\u0644\u0644\u0647 \u062D\u064A\u0647\u0645!', // Arabic for "Yallah Hayahum!"
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: 'Password',
                        suffixIcon: Icon(Icons.visibility),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
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
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // Button color
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 29, 25, 25)),
                      children: [
                        TextSpan(
                          text: 'Sign Up as a Local',
                          style: const TextStyle(color: Colors.brown),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Sign Up as a Local pressed');
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
                          style: const TextStyle(color: Colors.brown),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Sign Up as a Tourist pressed');
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
