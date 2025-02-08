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
class EditprofileScreen extends StatefulWidget {
  EditprofileScreen({super.key, required this.type, this.showBackButton = true});

  bool showBackButton;
  final String type;

  @override
  State<EditprofileScreen> createState() => _EditprofileScreenState();
}

class _EditprofileScreenState extends State<EditprofileScreen> {
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
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.type});

  final String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () => _navigateToEditProfile(context),
          ),
          const Divider(height: 2, color: Color(0xFFE0E0E0)),

          if (type == 'tourist')
            _buildListTile(
              icon: Icons.people,
              title: 'Communities',
              showTrailing: false,
              onTap: () {},
            ),

          if (type == 'tourist')
            const Divider(height: 2, color: Color(0xFFE0E0E0)),
            
          _buildListTile(
            icon: Icons.headset_mic_outlined,
            title: 'Customer Service',
            onTap: () => _contactCustomerService(context),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB94545),
                minimumSize: const Size(double.infinity, 50),
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
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Function() onTap,
    bool showTrailing = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF6B4B3E),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6B4B3E),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showTrailing
          ? const Icon(
              Icons.chevron_right,
              color: Color(0xFF6B4B3E),
              size: 24,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditprofileScreen(type: type ?? '',)));
  }

  void _contactCustomerService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerServiceScreen()),
    );
  }
}
