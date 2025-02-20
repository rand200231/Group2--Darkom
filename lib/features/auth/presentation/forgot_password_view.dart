import 'package:flutter/material.dart';
import 'package:flutter_333/features/auth/presentation/widgets/forgot_password_view_body.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ForgotPasswordViewBody(),
    );
  }
}