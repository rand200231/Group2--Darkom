import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_333/core/widgets/app_primary_button.dart';

class SuccessBookingScreen extends StatelessWidget {
  const SuccessBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Your booking has been successfully confirmed! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: Image.asset(
                  'assets/icons/success.png',
                  width: 160,
                  height: 140,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: AppPrimaryButton(
                  text: "Go back to home page",
                  onPressed: () {
                    // Navigator.popUntil(context, (route) {
                    //   log(':::::: Route: ${ route.settings.name}');
                    //   return route.settings.name == '/TouristHomeScreen';
                    // });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}