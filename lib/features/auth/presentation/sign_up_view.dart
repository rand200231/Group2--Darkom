import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/managers/firebase_error_validation.dart';
import 'package:flutter_333/features/auth/presentation/login_view.dart';
import 'package:flutter_333/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_333/features/auth/presentation/widgets/dialogs.dart';
import 'package:flutter_333/features/auth/waiting_for_approval.dart';
import 'package:flutter_333/features/experience_screen/main_experience_screen.dart';
import 'package:flutter_333/features/home/homeScreenLocal.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

//this page should be used only for tourist not local
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.type});

  final String type;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers to capture user input
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController maroofNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String fullPhoneNumber = ''; // Variable to store full number
  String? phoneError; // To store phone number validation error


  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _signUpUser() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    //final phoneNumber = _phoneNumberController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final number = maroofNumber.text.trim();
    //final number = _phoneNumberController.value.text;
    final phoneNumber = _phoneNumberController.text
        .trim(); // Store full number with country code

    // ✅ Check phone number before submitting
    if (phoneError != null) {
      showErrorDialog("Please enter a valid phone number.", context);
      return;
    }

    // Password validation: must be at least 8 characters long, contain at least one letter (upper/lower), one numeral, and be at least 8 characters
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$');
    if (!passwordRegExp.hasMatch(password)) {
      showErrorDialog(
          'Password must be at least 8 characters long, contain at least one numeral (0-9), at least one uppercase letter, and at least one lowercase letter.',
          context);
      return;
    }

    if (password != confirmPassword) {
      showErrorDialog('Passwords do not match.', context);
      return;
    }

    if (firstName.trim().isEmpty ||
        lastName.trim().isEmpty ||
        fullPhoneNumber
            .trim()
            .isEmpty || // Use fullPhoneNumber instead of controller
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        (widget.type == 'local' && number.trim().isEmpty)) {
      showErrorDialog('Please fill out all fields.', context);
      return;
    }

// Debugging: Print final phone number before saving
    print("Final Phone Number to be Stored: $fullPhoneNumber");

    /*await _firestore
        .collection('local_sign_up_requests')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'firstname': firstName,
      'lastname': lastName,
      'phoneNumber': fullPhoneNumber, // Ensure correct number format
      'email': email,
      'status': 'pending',
      'number': maroofNumber.text.trim(),
    });
    */

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (widget.type == 'tourist') {
        log(':::::::::: Store tourist data');
        await _firestore
            .collection('tourist')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'firstname': firstName,
          'lastname': lastName,
          'phoneNumber': fullPhoneNumber,
          'email': email,
        });
      } else if (widget.type == 'local') {
        log(':::::::::: Store local data');
        await _firestore
            .collection('local_sign_up_requests')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'firstname': firstName,
          'lastname': lastName,
          'phoneNumber': fullPhoneNumber,
          'email': email,
          'status': 'pending',
          // 'status': 'approved',
          'number': maroofNumber.text.trim(),
        });
        _clearTextFields();

        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => WaitingForApproval()));

        return;
      }
      _clearTextFields();
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => MainExperienceScreen(type: widget.type)));
    } on FirebaseAuthException catch (e) {
      final error = FirebaseErrorValidation.getErrorMessageFromCode(e.code);
      if (context.mounted) {
        showErrorDialog(error, context);
      }
    } catch (error) {
      showErrorDialog(error.toString().trim(), context);
    }
  }

  void _clearTextFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
    _passwordController.clear();
    maroofNumber.clear();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    maroofNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/welcome.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _firstNameController,
                    label: 'First name',
                  ),
                  AuthTextField(
                    controller: _lastNameController,
                    label: 'Last name',
                  ),
                  // AuthTextField(
                  //controller: _phoneNumberController,
                  //label: 'Phone number',
                  // keyboardType: TextInputType.phone,

                  /*  IntlPhoneField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    initialCountryCode: 'SA', // Default to Saudi Arabia
                    onChanged: (phone) {
                      _phoneNumberController.text = phone
                          .number; // Store only the number, not the country code
                      print(
                          'Complete Number: ${phone.completeNumber}'); // Debugging
                    },
                  ),

*/

  /// ✅ Modified Phone Field with Error Message
                  IntlPhoneField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: phoneError, // ✅ This shows the error in red
                    ),
                    initialCountryCode: 'SA',
                    keyboardType: TextInputType.phone,
                    onChanged: (phone) {
                      setState(() {
                        if (!RegExp(r'^[0-9]+$').hasMatch(phone.number)) {
                          phoneError = "Invalid Mobile Number";
                        } else {
                          phoneError = null;
                          fullPhoneNumber = phone.completeNumber;
                        }
                      });
                    },
                  ),


                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    isObscure: true,
                  ),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    isObscure: true,
                  ),
                  // Display password requirements below the password field
                  const Text(
                    'Password must be at least 8 characters long \n contain at least one numeral (0-9) \n at least one uppercase letter \n and at least one lowercase letter.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  widget.type == 'local'
                      ? AuthTextField(
                          controller: maroofNumber,
                          label: 'Maroof number',
                          keyboardType: TextInputType.number,
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signUpUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF9C7D45),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
