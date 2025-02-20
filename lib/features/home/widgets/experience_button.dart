import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperienceButton extends StatelessWidget {
  const ExperienceButton({
    super.key,
    required this.title,
    required this.imagePath,
    this.imageWidth,
    this.imageHeight,
    this.onPressed,
  });

  final String title;
  final String imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF000000), width: 1)),
        padding: EdgeInsets.all(3.dg),
        width: 108.w,
        height: 102.5.h,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                  width: imageWidth,
                  height: imageHeight,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
            5.verticalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            4.verticalSpace,
          ],
        ),
      ),
    );
  }
}
