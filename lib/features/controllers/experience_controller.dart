import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExperienceController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isFavoriteLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var experiences = <ExperienceModel>[].obs;
  var favoriteExperiences = <ExperienceModel>[].obs;

  List<String> selectedCategories = [];
  List<String> selectedCities = [];
  Rx<Map<String, dynamic>?> userData = Rx(null);
  RxList<String> categories = <String>[].obs;
  RxList<String> cities = <String>[].obs;
  
  final searchController = TextEditingController();

  Future<void> fetchCategories(BuildContext context) async {
    try {
      isLoading(true);
      final categoriesSnapshot = await _firestore.collection('category').get();
      categories.assignAll(categoriesSnapshot.docs.map((doc) => doc['name'].toString()).toList());
      
      final citiesSnapshot = await _firestore.collection('city').get();
      cities.assignAll(citiesSnapshot.docs.map((doc) => doc['name'].toString()).toList());
    } catch (e) {
      HomeHelper.showCustomSnackBar(context, "Failed to fetch categories and cities",
          isError: true);
    } finally {
      isLoading(false);
    }
  }

  void onSearchFilterChanged(BuildContext context, List<String> category, List<String> cities) {
    selectedCategories = category;
    selectedCities = cities;

    fetchExperiences(context, categories: category, cities: cities);
  }

  void fetchExperiencesByCategory(BuildContext context, String category) async {
    try {
      if (await HomeHelper.isInternetConnected) {
        isLoading(true);
        QuerySnapshot querySnapshot = await _firestore
            .collection('experiences')
            .where('category', isEqualTo: category)
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
            .get();

        experiences.assignAll(querySnapshot.docs.map((doc) {
          log(' --- Experience data: ${ExperienceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id).toString()}');
          return ExperienceModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList());
      } else {
        HomeHelper.showCustomSnackBar(context, "You have not internet",
            isError: true);
      }
    } catch (e) {
      HomeHelper.showCustomSnackBar(context, "Failed to fetch experiences: $e",
          isError: true);
    } finally {
      isLoading(false);
    }
  }
  
  void fetchExperiences(BuildContext context, {List<String>? categories, List<String>? cities, String? searchText}) async {
    try {
      if (await HomeHelper.isInternetConnected) {
        isLoading(true);

        // بناء الاستعلام مع الفلترة
        Query query = _firestore.collection('experiences');

        if (categories != null && categories.isNotEmpty) {
          query = query.where('category', whereIn: categories);
        }

        if (cities != null && cities.isNotEmpty) {
          query = query.where('city', whereIn: cities);
        }

        query = query.where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()));
        QuerySnapshot querySnapshot = await query.get();

        // تحويل البيانات إلى قائمة
        List<ExperienceModel> allExperiences = querySnapshot.docs.map((doc) {
          return ExperienceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        // 🔹 تطبيق الفلترة اليدوية للبحث في `title` و `description`
        if (searchText != null && searchText.isNotEmpty) {
          String lowerSearch = searchText.toLowerCase();
          allExperiences = allExperiences.where((exp) {
            return exp.name.toLowerCase().contains(lowerSearch) ||
                  exp.description.toLowerCase().contains(lowerSearch);
          }).toList();
        }

        experiences.assignAll(allExperiences);

        // experiences.assignAll(querySnapshot.docs.map((doc) {
        //   log(' --- Experience data: ${ExperienceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id).toString()}');
        //   return ExperienceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        // }).toList());
      } else {
        HomeHelper.showCustomSnackBar(context, "You have not internet", isError: true);
      }
    } catch (e) {
      log('::::::::: Error while fetching experiences: $e');
      HomeHelper.showCustomSnackBar(context, "Failed to fetch experiences", isError: true);
    } finally {
      isLoading(false);
    }
  }
  
  void fetchExperiencesByIds(BuildContext context, {List<String>? ids}) async {
    try {
      isFavoriteLoading(true);
      if (await HomeHelper.isInternetConnected) {
        final List<ExperienceModel> tempExperiences = [];
        for (String id in ids!) {
          DocumentSnapshot doc = await _firestore.collection('experiences').doc(id).get();
          tempExperiences.add(ExperienceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }

        // تحويل البيانات إلى قائمة
        favoriteExperiences.assignAll(tempExperiences);
      } else {
        HomeHelper.showCustomSnackBar(context, "You have not internet", isError: true);
      }
    } catch (e) {
      log('::::::::: Error while fetching experiences: $e');
      HomeHelper.showCustomSnackBar(context, "Failed to fetch experiences: $e", isError: true);
    } finally {
      isFavoriteLoading(false);
    }
  }

  Future<void> getUserdData(BuildContext cotext) async {
    isLoading(true);
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      HomeHelper.showLoginDialog(cotext);
      isLoading(false);
      return;
    }

    // مرجع إلى مستند المستخدم في Firestore
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("tourist").doc(userId);

    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      userData.value = userSnapshot.data() as Map<String, dynamic>;
      userData.value?['userId'] = userId;
    }
    isLoading(false);
  }

  Future<void> toggleExperienceFavorite(BuildContext context, String experienceId) async {
    // الحصول على معرف المستخدم الحالي
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      HomeHelper.showLoginDialog(context);
      return;
    }

    // مرجع إلى مستند المستخدم في Firestore
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection("tourist").doc(userId);

    // جلب بيانات المستخدم للتحقق من المفضلات
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      
      List<dynamic> favorites = userSnapshot.data()?["favorites"] ?? [];

      if (favorites.contains(experienceId)) {
        // إزالة المنتج من المفضلة
        await userRef.update({
          "favorites": FieldValue.arrayRemove([experienceId])
        });
        favorites.remove(experienceId);
        log(" :::::::::: Removed from favorites");
      } else {
        // إضافة المنتج إلى المفضلة
        await userRef.update({
          "favorites": FieldValue.arrayUnion([experienceId])
        });
        favorites.add(experienceId);
        log(" :::::::::: Added to favorites");
      }
      userData.value?['favorites'] = favorites;
      update();
    } else {
      // إذا لم يكن هناك مستند للمستخدم، يتم إنشاؤه مع أول منتج مفضل
      await userRef.set({
        "favorites": [experienceId]
      });
      log(" :::::::::: User document created and product added to favorites");
    }
  }


  // void searchExperiences(BuildContext context, String searchText) async {
  //   // 🔹 تطبيق الفلترة اليدوية للبحث في `title` و `description`
  //   String lowerSearch = searchText.toLowerCase();
  //   experiences.value = experiences.where((exp) {
  //     return exp.name.toLowerCase().contains(lowerSearch) ||
  //         exp.description.toLowerCase().contains(lowerSearch);
  //   }).toList();
  // }
}
