// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkom/firebase_options.dart';
import 'package:darkom/home/home_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home/screens/main_experience_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darkom',
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
      home: FirebaseAuth.instance.currentUser != null? MainExperienceScreen() : SignUpScreen(),
      // home: MainScreen(),
      // home: SignUpScreen(),
      // home: MainExperienceScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _maroofController = TextEditingController();

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (await HomeHelper.isInternetConnected) {
          // - Create user account
          final fireAuth = FirebaseAuth.instance;
          final createdUser = await fireAuth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

          // - store the user name in the user profile
          await createdUser.user!.updateDisplayName('${_firstNameController.text.trim()} ${_lastNameController.text.trim()}');

          // - store additional user data in firestore
          final fireStore = FirebaseFirestore.instance;

          await fireStore.collection('local_sign_up_requests').doc(createdUser.user!.uid).set({
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'phone number': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'maroofNumber': _maroofController.text.trim(),
            'status': 'pending',
          });

          Navigator.push(
            context,
            // MaterialPageRoute(builder: (context) => MainScreen()),
            MaterialPageRoute(builder: (context) => MainExperienceScreen()),
          );
        } else {
          HomeHelper.showCustomSnackBar(context, "You have not internet", isError: true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submission failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/welcome.png',
              height: 200,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNameField('First name', _firstNameController),
                  const SizedBox(height: 24),
                  _buildNameField('Last name', _lastNameController),
                  const SizedBox(height: 24),
                  _buildPhoneField(),
                  const SizedBox(height: 24),
                  _buildEmailField(),
                  const SizedBox(height: 24),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  _buildMaroofField(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA5814F),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'send sign up request',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Your request will be reviewed by the admin.\nPlease try logging in once your account has been approved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {/* Add login navigation */},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFFA5814F),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Only alphabets are allowed';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone number',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is required';
        }
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Invalid phone number (10 digits required)';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
          return 'Must contain letters and numbers';
        }
        return null;
      },
    );
  }

  Widget _buildMaroofField() {
    return TextFormField(
      controller: _maroofController,
      decoration: const InputDecoration(
        labelText: 'Maroof Number',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Maroof Number is required';
        }
        return null;
      },
    );
  }
}
