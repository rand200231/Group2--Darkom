import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/features/experience/widgets/experience_home_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/experience_controller.dart';
import '../widgets/search_filter_widget.dart';

class TouristHomeScreen extends StatefulWidget {
  const TouristHomeScreen({super.key});

  @override
  State<TouristHomeScreen> createState() => _TouristHomeScreenState();
}

class _TouristHomeScreenState extends State<TouristHomeScreen> {
  final experienceController = Get.put(ExperienceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      experienceController.fetchCategories(context);
      experienceController.fetchExperiences(context);
      experienceController.getUserdData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        experienceController.searchController.clear();
        experienceController.selectedCategories.clear();
        experienceController.selectedCities.clear();
        experienceController.fetchExperiences(context);
      },
      child: Container(
        color: Color(0XFFEEEEEE),
        child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              // -- image and search field
              Stack(
                children: [
                  Image.asset(
                    'assets/images/WelcomeTourist.png',
                    height: 345,
                    fit: BoxFit.cover,
                  ),
          
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 70,
                    child: Column(
                      children: [
                        const Text(
                          'WELCOME!',
                          textScaler: TextScaler.linear(2.8),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xfff0ecdc),
                            // height: 1
                          ),
                        ),
                        // const SizedBox(height: 10),
                        const Text(
                          '!يالله حيُّهم',
                          textScaler: TextScaler.linear(2.5),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xfff0ecdc),
                            height: 1
                          ),
                        ),
          
                        const SizedBox(height: 10),
                        const Text(
                          'Find  some Amazing experiences below',
                          // textScaler: TextScaler.linear(2.5),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xffc1c1c1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: experienceController.searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) => experienceController.fetchExperiences(
                              context,
                              categories: experienceController.selectedCategories,
                              cities: experienceController.selectedCities,
                              searchText: experienceController.searchController.text,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              suffixIcon: IconButton(onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 150),
                                    child: Obx(() => SearchFilterWidget(
                                      categories: experienceController.categories.value,
                                      cities: experienceController.cities.value,
                                      selectedCategories: experienceController.selectedCategories,
                                      selectedCities: experienceController.selectedCities,
                                      onChanged: (selectedCategory, selectedCities) {
                                        experienceController.onSearchFilterChanged(context, selectedCategory, selectedCities);
                                      },
                                    )),
                                  ),
                                );
                              }, icon: Icon(Icons.filter_alt_outlined)),
                              hintText: 'Search for available experiences….',
                              fillColor: Color(0XFFececec),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
          
              const SizedBox(height: 20),
          // SearchFilterWidget(),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Popular Experiences',
                  style: TextStyle(
                    // fontSize: 13
                  ),
                ),
              ),
          
              Obx(() {
                if (experienceController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemCount: experienceController.experiences.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final experience = experienceController.experiences[index];
                    return GetBuilder<ExperienceController>(
                      init: experienceController,
                      builder: (_) => ExperienceHomeWidget(
                        experience: experience,
                        isFavorite: experienceController.userData.value?['favorites']
                                ?.contains(experience.docId) ?? false,
                        onFavoriteTap: () {
                          experienceController.toggleExperienceFavorite(context, experience.docId);
                        },
                      ),
                    );
                  }
                );
              }),      
            ],
          ),
      ),
      // ),
    );
  }
}