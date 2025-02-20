import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLabeledTextField extends StatelessWidget {
  final String label; // النص الذي يمثل العنوان
  final Color labelColor; // لون النص الخاص بالعنوان
  final Widget? prefixIcon; // أيقونة البداية (اختيارية)
  final Widget? suffixIcon; // أيقونة النهاية (اختيارية)
  final int maxLines; // عدد الأسطر
  final TextEditingController? controller; // للتحكم في النص
  final String? Function(String?)? validation; // دالة التحقق من صحة الإدخال
  final Color fillColor; // لون خلفية صندوق الإدخال
  final Color borderColor; // لون الحدود
  final String? hintText; // النص التلميحي داخل صندوق الإدخال
  final Color? hintColor; // النص التلميحي داخل صندوق الإدخال
  final Color inputTextColor; // لون النص الذي سيتم إدخاله
  final bool readOnly;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final String? initialValue;

  const CustomLabeledTextField({
    super.key,
    required this.label,
    this.labelColor = Colors.black,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.controller,
    this.validation,
    this.fillColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.hintText,
    this.hintColor,
    this.inputTextColor = Colors.black,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            // fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        SizedBox(height: 3.h),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validation,
          style: TextStyle(color: inputTextColor, fontSize: 13.sp),
          readOnly: readOnly,
          onTap: onTap,
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor ?? Theme.of(context).primaryColor),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(maxWidth: 50, minWidth: 40),
            filled: true,
            isDense: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}