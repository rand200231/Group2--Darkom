import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/core/widgets/app_primary_button.dart';
import 'package:flutter_333/features/controllers/create_experience_controller.dart';
import 'package:flutter_333/features/controllers/location_controller.dart';
import 'package:flutter_333/features/experience/experiences_screen.dart';
import 'package:flutter_333/features/experience/widgets/create_user_exp_screen.dart';
import 'package:flutter_333/features/home/widgets/experience_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Image.asset(
          "assets/icons/welcome.png",
          height: 60,
        ),
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Experiences',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              6.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExperienceButton(
                    title: 'Adventure',
                    imagePath: 'assets/icons/adventure.png',
                    imageWidth: 82.8.w,
                    imageHeight: 60.9.h,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExperiencesScreen(
                                  experiences: temporaryExperiencesData,
                                  category: 'Adventure',
                                ))),
                  ),
                  10.horizontalSpace,
                  ExperienceButton(
                    title: 'Culture',
                    imagePath: 'assets/icons/culture.jpg',
                    imageWidth: 99.3.w,
                    imageHeight: 55.5.h,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExperiencesScreen(
                                  experiences: temporaryExperiencesData,
                                  category: 'Culture',
                                ))),
                  ),
                  10.horizontalSpace,
                  ExperienceButton(
                    title: 'Food',
                    imagePath: 'assets/icons/food.jpg',
                    imageWidth: 82.w,
                    imageHeight: 69.h,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExperiencesScreen(
                            experiences: temporaryExperiencesData,
                            category: 'Food',
                          ),
                        ),
                      );
                      
                    },
                  ),
                ],
              ),
              ScreenUtil().screenHeight > 800
                  ? 120.verticalSpace
                  : 60.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: AppPrimaryButton(
                  text: "Click here\nto create your Experience",
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateExperienceScreen()));

                    Get.delete<LocationController>();
                    Get.delete<CreateExperienceController>();
                  },
                ),
              ),
              ScreenUtil().screenHeight > 800
                  ? 50.verticalSpace
                  : 10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
