import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/core/widgets/firebase_storage_service.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CreateExperienceController extends GetxController {
  final RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  final RxList<String> categories = <String>[].obs;
  final RxList<String> cities = <String>[].obs;

  // المتحكمات للصناديق النصية
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController availableSeatsController =
      TextEditingController();
  // final TextEditingController dateController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();
  // final TextEditingController locationController = TextEditingController();
  final Rx<LatLng?> selectedLatLng = Rx(null);
  final RxString selectedAddress = ''.obs;
  final Rx<DateTime?> selectedDate = Rx(null);
  final Rx<TimeOfDay?> selectedTime = Rx(null);

  // قائمة الصور المختارة
  var selectedImages = <File>[].obs;

  // فتح معرض الصور واختيار الصور
  Future<void> pickImages(BuildContext context) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      selectedImages.addAll(images.map((image) => File(image.path)).toList());
    } catch (e) {
      HomeHelper.showCustomSnackBar(context, "Failed to pick images: $e",
          isError: true);
    }
  }

  // حذف صورة من القائمة
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

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

  Future<List<String>> uploadImages() async {
    if (selectedImages.isEmpty) return [];

    final List<String> imageUrls =
        await FirebaseStorageService.uploadMultipleImages(
      selectedImages,
      'experiences/images',
    );

    return imageUrls;
  }

  // دالة لرفع البيانات إلى Firebase
  Future<void> uploadExperience(BuildContext context) async {
    try {
      log(':::::::: Upload Experience');
      if (!(formKey.currentState?.validate() ?? false)) return;

      // must authenticate the user by login or sign up using FirebaseAuth
      if (FirebaseAuth.instance.currentUser == null) {
        HomeHelper.showLoginDialog(context);
        return;
      }

      isLoading(true);

      if (await HomeHelper.isInternetConnected) {
        // رفع الصور إلى Firebase Storage
        final List<String> imageUrls = await uploadImages();

        // إنشاء ExperienceModel من البيانات المدخلة
        final experience = ExperienceModel(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          category: categoryController.text.trim(),
          city: cityController.text.trim(),
          price: double.parse(priceController.text.trim()),
          availableSeats: int.parse(availableSeatsController.text.trim()),
          bookingSeats: 0,
          date: DateFormat('yyyy-mm-dd').format(selectedDate.value!),
          time: HomeHelper.formatTime(selectedTime.value!),
          location: GeoPoint(
              selectedLatLng.value!.latitude, selectedLatLng.value!.longitude),
          address: selectedAddress.value,
          userId: FirebaseAuth.instance.currentUser?.uid ?? '',
          photos: imageUrls,
          createdAt: DateTime.now(),
        );

        // رفع البيانات إلى Firebase
        final docRef =
            await _firestore.collection('experiences').add(experience.toMap());

        HomeHelper.showCustomSnackBar(
            context, "Experience added successfully!");
        clearForm(); // تنظيف النموذج بعد الرفع
      } else {
        HomeHelper.showCustomSnackBar(context, "You have not internet",
            isError: true);
      }
    } catch (e) {
      HomeHelper.showCustomSnackBar(context, "Failed to upload experience: $e",
          isError: true);
    } finally {
      isLoading(false);
    }
  }

  // تنظيف النموذج بعد الرفع
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    categoryController.clear();
    cityController.clear();
    priceController.clear();
    availableSeatsController.clear();
    selectedDate.value = null;
    selectedTime.value = null;
    selectedLatLng.value = null;
    selectedAddress.value = '';
    selectedImages.clear();
  }
}
