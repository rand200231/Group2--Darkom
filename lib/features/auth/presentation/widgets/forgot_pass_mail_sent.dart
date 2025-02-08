import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/features/auth/presentation/login_view.dart';
import 'package:lottie/lottie.dart';

class ForgotPassMailSent extends StatelessWidget {
  const ForgotPassMailSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/mailsent.json'),
            Text(
              "password reset link Sent!",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "Check your email for a password reset link",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(
              height: 20,
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
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => LoginScreen()));
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  "back to Log in",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
