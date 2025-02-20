import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/widgets/app_header.dart';
import 'package:flutter_333/core/widgets/app_primary_button.dart';
import 'package:flutter_333/core/widgets/custom_underline_textfield.dart';
import 'package:flutter_333/features/auth/presentation/login_view.dart';
import 'package:flutter_333/features/settings/customerServiceScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../controllers/profile_controller.dart';

// Existing
class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.type, this.showBackButton = true});

  bool showBackButton;
  final String type;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileController profileController;

  @override
  void initState() {
    profileController = Get.put(ProfileController(type: widget.type));
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
        appBar: const AppHeader(showBackButton: true),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
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

                    // CustomUnderlineTextField(
                    //   hintText: 'Phone number',
                    //   controller: profileController.phoneController,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Phone number is required';
                    //     }
                    //     if (!RegExp(r'^\+[0-9]+$').hasMatch(value)) {
                    //       return "Invalid Mobile Number";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // 45.verticalSpace,

                    IntlPhoneField(
                      controller: profileController.phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      initialCountryCode: 'SA',
                      keyboardType: TextInputType.phone,
                    ),
                    45.verticalSpace,

                    CustomUnderlineTextField(
                      hintText: 'Email',
                      controller: profileController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
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
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)')
                            .hasMatch(value)) {
                          return 'Must contain letters and numbers';
                        }
                        return null;
                      },
                    ),
                    40.verticalSpace,

                    if (widget.type == 'local')
                    CustomUnderlineTextField(
                      hintText: 'Bio (Optional)',
                      controller: profileController.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)')
                            .hasMatch(value)) {
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
                                onPressed: () => profileController
                                    .submitSaveChangesButton(context),
                                isLoading: profileController.isLoading.value,
                              )),

                          20.verticalSpace, // Space before logout button

                          
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

// New

