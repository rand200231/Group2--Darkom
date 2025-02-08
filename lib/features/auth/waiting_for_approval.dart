import 'package:flutter/material.dart';
import 'package:flutter_333/features/auth/presentation/login_view.dart';

class WaitingForApproval extends StatelessWidget {
  const WaitingForApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'assets/app_logo.png',
              height: 150,
            ),
            Text(
              'Waiting for  admin  approval',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text("you can go back to login page and try again later"),

            Spacer(),
            //button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                'Go back to login page',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
