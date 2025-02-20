import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.showErrorBorder = false,
    this.onChanged,
    this.maxLength,
  });

  final String label;
  final TextEditingController controller;
  final bool isObscure;
  final TextInputType keyboardType;
  final bool showErrorBorder;
  final void Function(String)? onChanged;
  final int? maxLength;
  

  @override
  Widget build(BuildContext context) {
    final border = showErrorBorder ? UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ) : null;
    return TextField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isObscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        // errorText: ""
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
