import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/widgets/check_password_widget.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final String type;
  late CollectionReference<Map<String, dynamic>> _usersCollection;

  ProfileController({required this.type}) {
    _usersCollection = type == 'local' 
      ? FirebaseFirestore.instance.collection('local_sign_up_requests')
      : FirebaseFirestore.instance.collection('tourist');
  }

  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  final formKey = GlobalKey<FormState>();

  // المتحكمات للصناديق النصية
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void fillUserDataToForm(Map<String, dynamic> data) {
    firstNameController.text = data['firstname'];
    lastNameController.text = data['lastname'];
    if (data['phoneNumber'].length > 9) {
      phoneController.text = (data['phoneNumber'] as String).substring(
        (data['phoneNumber'] as String).length - 9,
      );
    } else {
      phoneController.text = data['phoneNumber'];
    }
    emailController.text = data['email'];
    bioController.text = data['bio'] ?? '';
    // firstNameController.text = data[''];
  }

  Future<void> fetchUserInfo(BuildContext context) async {
    try {
      isLoading.value = true;
      if (await HomeHelper.isInternetConnected) {
        final currentUser = FirebaseAuth.instance.currentUser;
        // must authenticate the user by login or sign up using FirebaseAuth
        if (currentUser == null) {
          // HomeHelper.showLoginDialog(context);
          HomeHelper.showLoginDialog(context, requireLogin: false);

          isLoading.value = false;
          return;
        }

        final userDoc = await _usersCollection.doc(currentUser.uid).get();

        // extract the courses data from firbase docs
        if (userDoc.exists && userDoc.data() != null) {
          log("::::: Success get user data: ${userDoc.data()}");
          userData.value = userDoc.data()!;
          userData['userId'] = currentUser.uid;
          fillUserDataToForm(userDoc.data()!);
        } else {
          await FirebaseAuth.instance.signOut();
          //HomeHelper.showLoginDialog(context);
          HomeHelper.showLoginDialog(context, requireLogin: false);
        }
      } else {
        HomeHelper.showCustomSnackBar(context, "You have not internet",
            isError: true);
      }
    } on FirebaseException catch (e) {
      // log(' ??????: ${e.message}');

      if (e.code == 'not-found' || e.code == 'user-not-found') {
        FirebaseAuth.instance.signOut(); // Sign out the user
        //HomeHelper.showLoginDialog(context);
        HomeHelper.showLoginDialog(context, requireLogin: false);
      } else {
        HomeHelper.showCustomSnackBar(
            context, e.message ?? "Unexpected error!, try again.",
            isError: true);
      }
    } catch (e) {
      log(' ??????: $e');
      HomeHelper.showCustomSnackBar(context, "Unexpected error!, try again.",
          isError: true);
    }
    isLoading.value = false;
  }

  Future<bool> submitSaveChangesButton(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    log(':::: Type: ${type}');
    isLoading.value = true;
    try {
      if (await HomeHelper.isInternetConnected) {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (emailController.text.trim() != currentUser?.email ||
            passwordController.text.isNotEmpty) {
          final isSuccessChecked = await getAndAuthPasswordFromUser(context);

          if (isSuccessChecked == true) {
            if (emailController.text.trim() != currentUser?.email) {
              await updateUserEmail(context, emailController.text.trim());
            }

            if (passwordController.text.isNotEmpty) {
              await updateUserPassword(context, passwordController.text);
              passwordController.text = "";
            }
          } else {
            isLoading.value = false;
            return false;
          }
        }

        Map<String, dynamic> updatedData = {
          'firstname': firstNameController.text.trim(),
          'lastname': lastNameController.text.trim(),
          'phoneNumber': phoneController.text.trim(),
          'bio': bioController.text.trim(),
        };

        // await _usersCollection.doc(currentUser!.uid).delete();
        await _usersCollection.doc(currentUser!.uid).set(updatedData, SetOptions(
          merge: true,
        ));
        await currentUser.updateDisplayName(
            '${updatedData['firstname']} ${updatedData['lastname']}');

        HomeHelper.showCustomSnackBar(context, "The data has been modified successfully");

        userData['firstname'] = firstNameController.text.trim();
        userData['lastname'] = lastNameController.text.trim();
        userData['phoneNumber'] = phoneController.text.trim();
        userData['bio'] = bioController.text.trim();
        fillUserDataToForm(userData);

        isLoading.value = false;
        return true;
      } else {
        HomeHelper.showCustomSnackBar(context, "You have not internet", isError: true);
      }
    } on FirebaseException catch (e) {
      HomeHelper.showCustomSnackBar(context, e.message ?? '', isError: true);
    } catch (e) {
      log('  ?????? submitSaveChangesButton: $e');
      HomeHelper.showCustomSnackBar(context, "Unexpected error!, try again.",
          isError: true);
    }
    isLoading.value = false;
    return false;
  }

  Future<void> updateUserEmail(BuildContext context, String newEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.verifyBeforeUpdateEmail(newEmail);
    HomeHelper.showResultDialog(
      context,
      title: 'Success Alert',
      desc:
          'We have sent a verification link to the new email to verify the email.\nOpen the link to change your account email',
    );
  }

  Future<void> updateUserPassword(
      BuildContext context, String newPassword) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.updatePassword(newPassword);
    // HomeHelper.showResultDialog(context,
    //   title: 'Success Alert',
    //   desc: 'We have sent a verification link to the new email to verify the email.\nOpen the link to change your account email',
    // );
  }

  Future<bool?> getAndAuthPasswordFromUser(BuildContext context) async {
    return await showDialog(
      context: context,
      // builder: (_) => Container(),
      builder: (context) {
        Get.put(CheckPasswordController());
        return CheckPasswordWidget(
          onCorrectCheck: (String password) {
            // userPassword = password;
          },
        );
      },
      // titlePadding: EdgeInsets.zero,
      // contentPadding: EdgeInsets.zero,
    ).then((value) {
      Get.delete<CheckPasswordController>();
      return value;
    });
  }

  // دالة لرفع البيانات إلى Firebase
  Future<void> uploadExperience(BuildContext context) async {
    try {
      log(':::::::: Upload Experience');
      if (!(formKey.currentState?.validate() ?? false)) return;

      // must authenticate the user by login or sign up using FirebaseAuth
      if (FirebaseAuth.instance.currentUser == null) {
        //HomeHelper.showLoginDialog(context);
        HomeHelper.showLoginDialog(context, requireLogin: false);

        return;
      }

      isLoading(true);

      if (await HomeHelper.isInternetConnected) {
        // إنشاء ExperienceModel من البيانات المدخلة
        // final experience = ExperienceModel(
        //   name: firstNameController.text.trim(),
        //   description: lastNameController.text.trim(),
        //   category: phoneController.text.trim(),
        //   price: double.parse(emailController.text.trim()),
        //   availableSeats: int.parse(passwordController.text.trim()),
        //   date: DateFormat('yyyy-mm-dd').format(selectedDate.value!),
        //   time: HomeHelper.formatTime(selectedTime.value!),
        //   location: GeoPoint(selectedLatLng.value!.latitude, selectedLatLng.value!.longitude),
        //   address: selectedAddress.value,
        //   userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        //   photos: imageUrls,
        //   createdAt: DateTime.now(),
        // );

        // رفع البيانات إلى Firebase
        // final docRef = await _firestore.collection('experiences').add(experience.toMap());

        HomeHelper.showCustomSnackBar(
            context, "Experience added successfully!");
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
}
