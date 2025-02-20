import 'package:flutter/material.dart';
import 'package:flutter_333/features/experience/widgets/experience_home_widget.dart';
import 'package:get/get.dart';

import '../controllers/experience_controller.dart';

class FavoriteExpereincesScreens extends StatefulWidget {
  const FavoriteExpereincesScreens({super.key});

  @override
  State<FavoriteExpereincesScreens> createState() => _FavoriteExpereincesScreensState();
}

class _FavoriteExpereincesScreensState extends State<FavoriteExpereincesScreens> {
  
  final experienceController = Get.find<ExperienceController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (experienceController.userData.value != null && experienceController.userData.value!.isEmpty) {
        await experienceController.getUserdData(context);
      }
      experienceController.fetchExperiencesByIds(context, ids: experienceController.userData.value?['favorites']?.cast<String>() ?? [] );    
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // -- header
            Container(
              width: double.infinity,
              height: 70,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CircleAvatar(
                        backgroundColor: Color(0XFFf0ecdc),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      ),
                    ),
                    
                    // Image.asset("assets/icons/welcome.png", width: 97.5, height: 105.5),
                    const SizedBox(width: 10),
                    Icon(Icons.favorite_border, color: Colors.white, size: 35),
                    const SizedBox(width: 20),

                    Text(
                      "Saved Experiences",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (experienceController.isFavoriteLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
              
                if (experienceController.favoriteExperiences.isEmpty) {
                  return Center(
                    child: Text('No Experiences found',
                        style: TextStyle(color: Theme.of(context).primaryColor)),
                  );
                }
              
                return GetBuilder<ExperienceController>(
                  builder: (_) {
                    return  ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      itemCount: experienceController.favoriteExperiences.length,
                      itemBuilder: (context, index) {
                        // var experience = experienceController.favoriteExperiences[index];
                        return ExperienceHomeWidget(
                          experience: experienceController.favoriteExperiences[index],
                          isFavorite: true,
                          onFavoriteTap: () async {
                            await experienceController.toggleExperienceFavorite(context, experienceController.favoriteExperiences[index].docId);
                            experienceController.favoriteExperiences.removeAt(index);
                            experienceController.update();
                          },
                        );
                      },
                  
                      separatorBuilder: (context, index) => SizedBox(height: 25),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}