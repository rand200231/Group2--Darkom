import 'package:darkom/home/controllers/location_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:darkom/home/widgets/app_primary_button.dart';
import 'package:darkom/home/screens/create_experience_screen.dart';
import 'package:darkom/home/screens/experiences_screen.dart';
import 'package:darkom/home/widgets/welcome_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/create_experience_controller.dart';
import '../models/experience_model.dart';
import '../widgets/experience_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(175.h),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: WelcomeHeader(name: FirebaseAuth.instance.currentUser?.displayName ?? "Not logged in"), // "Raghad Alyousef"
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // MediaQuery.of(context).padding.top.verticalSpace,Description for First Experience with locatin. 
              // const WelcomeHeader(name: "Raghad Alyousef"),
              10.verticalSpace,
          
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 108.w * 3 + 20.w * 2,
                      child: Text('My Experiences', style: TextStyle(
                        fontSize: 14.sp,
                      )),
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
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExperiencesScreen(
                            experiences: temporaryExperiencesData,
                            category: 'Adventure',
                          ))),
                        ),
                        
                        20.horizontalSpace,
                        ExperienceButton(
                          title: 'Culture',
                          imagePath: 'assets/icons/culture.jpg',
                          imageWidth: 99.3.w,
                          imageHeight: 55.5.h,
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExperiencesScreen(
                            experiences: temporaryExperiencesData,
                            category: 'Culture',
                          ))),
                        ),
                
                        20.horizontalSpace,
                        ExperienceButton(
                          title: 'Food',
                          imagePath: 'assets/icons/food.jpg',
                          imageWidth: 87.w,
                          imageHeight: 69.h,
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExperiencesScreen(
                            experiences: temporaryExperiencesData,
                            category: 'Food',
                          ))),
                        ),
                      ],
                    ),
          
                    ScreenUtil().screenHeight > 800 ? 120.verticalSpace : 60.verticalSpace,
                    AppPrimaryButton(
                      text: "Click here\nto create your Experience",
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateExperienceScreen()));

                        // Delete the controller after returning from the page
                        Get.delete<LocationController>();
                        Get.delete<CreateExperienceController>();
                      },
                      
                    ),
                    ScreenUtil().screenHeight > 800 ? 50.verticalSpace : 10.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}