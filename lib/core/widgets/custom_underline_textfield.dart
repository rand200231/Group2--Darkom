import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomUnderlineTextField extends StatelessWidget {
  final Widget? prefixIcon; // أيقونة البداية (اختيارية)
  final Widget? suffixIcon; // أيقونة النهاية (اختيارية)
  final int maxLines; // عدد الأسطر
  final TextEditingController? controller; // للتحكم في النص
  final String? Function(String?)? validator; // دالة التحقق من صحة الإدخال
  final Color fillColor; // لون خلفية صندوق الإدخال
  final Color borderColor; // لون الحدود
  final String? hintText; // النص التلميحي داخل صندوق الإدخال
  final Color inputTextColor; // لون النص الذي سيتم إدخاله
  final bool readOnly;
  final void Function()? onTap;
  final TextInputType? keyboardType;

  const CustomUnderlineTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.controller,
    this.validator,
    this.fillColor = Colors.white,
    this.borderColor = Colors.black,
    this.hintText,
    this.inputTextColor = Colors.black,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(color: inputTextColor, fontSize: 14.sp),
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8.sp),
            hintText: hintText,
            hintStyle: TextStyle(color: Color(0XFFc1c1c1)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(maxWidth: 50, minWidth: 40),
            filled: true,
            isDense: true,
            fillColor: fillColor,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}