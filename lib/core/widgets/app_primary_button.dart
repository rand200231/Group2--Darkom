import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  final String text;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed ?? () {},
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        height: 74.8.h,
        width: 280.7.w,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(50.r),
          border: Border(
            top: BorderSide(width: 8.h, color: Theme.of(context).primaryColor),
            bottom:
                BorderSide(width: 8.h, color: Theme.of(context).primaryColor),
            right:
                BorderSide(width: 18.w, color: Theme.of(context).primaryColor),
            left:
                BorderSide(width: 18.w, color: Theme.of(context).primaryColor),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.63),
            borderRadius: BorderRadius.circular(50.r),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: const CircularProgressIndicator())
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.8.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
