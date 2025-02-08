import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
  });
  final String label;
  final TextEditingController controller;
  final bool isObscure;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
