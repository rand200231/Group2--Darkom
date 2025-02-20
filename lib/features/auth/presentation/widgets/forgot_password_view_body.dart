import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter_333/features/auth/presentation/widgets/forgot_pass_mail_sent.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text(
                "OH nO!",
                style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.w900,
                    fontSize: 45,
                    color: Color(0xff4d2f14)),
              ),
              Text(
                "I Forgot",
                style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Color(0xff4d2f14)),
              ),
              Text(
                "Enter your email and we'll send you a link to change a new password",
                style: TextStyle(height: 0, fontSize: 16, color: Colors.grey),
              ),
              AuthTextField(
                label: "Email",
                controller: _emailController,
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: Size(200, 50),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _emailController.text);
          
                      //? navigate to password sent page
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => ForgotPassMailSent()));
                    } catch (e) {
                      HomeHelper.showCustomSnackBar(context, 'Something error, Try again...', isError: true);
                    }
                  },
                  child: Text(
                    "Send password reset link",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
