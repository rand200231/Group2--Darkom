import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayExperienceWidget extends StatelessWidget {
  const DisplayExperienceWidget({super.key, required this.experience});

  final ExperienceModel experience;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF000000), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experience.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0XFF4d2f14),
            ),
          ),
          5.verticalSpace,
          Text(
            experience.description,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0XFF4d2f14),
            ),
          ),
        ],
      ),
    );
  }
}
