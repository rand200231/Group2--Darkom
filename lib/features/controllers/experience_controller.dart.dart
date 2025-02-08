import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:get/get.dart';

class ExperienceController extends GetxController {
  final RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var experiences = <ExperienceModel>[].obs;

  void fetchExperiencesByCategory(BuildContext context, String category) async {
    try {
      if (await HomeHelper.isInternetConnected) {
        isLoading(true);
        QuerySnapshot querySnapshot = await _firestore
            .collection('experiences')
            .where('category', isEqualTo: category)
            .where('userId',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
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
}
