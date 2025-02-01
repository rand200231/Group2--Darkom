import 'package:darkom/mainSignUplocal.dart';
import 'package:flutter/material.dart';
import 'package:darkom/home/widgets/app_primary_button.dart';
import 'package:darkom/home/widgets/custom_underline_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/app_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileController.fetchUserInfo(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => profileController.fetchUserInfo(context),
      child: Scaffold(
        appBar: const AppHeader(),
        body: Center(
          child: Obx(
            () {
              if (profileController.isLoading.value) {
                return const CircularProgressIndicator();
              }
      
              return Form(
                key: profileController.formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  children: [
                    CustomUnderlineTextField(
                      hintText: 'First name',
                      controller: profileController.firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Only alphabets are allowed';
                        }
                        return null;
                      },
                    ),
                    45.verticalSpace,
                    
                    CustomUnderlineTextField(
                      hintText: 'Last name',
                      controller: profileController.lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Only alphabets are allowed';
                        }
                        return null;
                      },
                    ),
                    45.verticalSpace,
                
                    CustomUnderlineTextField(
                      hintText: 'Phone number',
                      controller: profileController.phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Invalid phone number (10 digits required)';
                        }
                        return null;
                      },
                    ),
                    45.verticalSpace,
                
                    CustomUnderlineTextField(
                      hintText: 'Email',
                      controller: profileController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    45.verticalSpace,
                
                    CustomUnderlineTextField(
                      hintText: 'Password',
                      controller: profileController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                          return 'Must contain letters and numbers';
                        }
                        return null;
                      },
                    ),
                    45.verticalSpace,
                
                    // ✅ Centered Column for Buttons
                    Center(
                      child: Column(
                        children: [
                          // ✅ Save Changes Button
                          Obx(() => AppPrimaryButton(
                                text: 'Click here\nto save changes',
                                onPressed: () => profileController.submitSaveChangesButton(context),
                                isLoading: profileController.isLoading.value,
                              )),
                          
                          20.verticalSpace, // Space before logout button
                          
                          // ✅ Logout Button (Aligned Properly)
                          SizedBox(
                            width: 280.w, // Same width as Save Changes button
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the SignUpScreen on logout
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                                  (route) => false, // This removes all previous routes
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA5814F), // ✅ Same color as save button
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Log out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

