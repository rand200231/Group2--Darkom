import 'package:darkom/home/controllers/experience_controller.dart.dart';
import 'package:flutter/material.dart';
import 'package:darkom/home/widgets/app_header.dart';
import 'package:darkom/home/models/experience_model.dart';
import 'package:darkom/home/widgets/display_experience_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExperiencesScreen extends StatefulWidget {
  const ExperiencesScreen({super.key, required this.experiences, required this.category});

  final List<ExperienceModel> experiences;
  final String category;

  @override
  State<ExperiencesScreen> createState() => _ExperiencesScreenState();
}

class _ExperiencesScreenState extends State<ExperiencesScreen> {
  final controller = Get.put(ExperienceController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchExperiencesByCategory(context, widget.category);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.experiences.isEmpty) {
            return Center(child: Text('No Experiences found', style: TextStyle(color: Theme.of(context).primaryColor)));
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            itemCount: controller.experiences.length,
            itemBuilder: (context, index) {
              return DisplayExperienceWidget(
                experience: controller.experiences[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 25.h),
          );
        }
      ),
    );
  }
}