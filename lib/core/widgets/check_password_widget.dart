import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckPasswordWidget extends StatefulWidget {
  const CheckPasswordWidget({super.key, required this.onCorrectCheck});

  final void Function(String password) onCorrectCheck;

  @override
  State<CheckPasswordWidget> createState() => _CheckPasswordWidgetState();
}

class _CheckPasswordWidgetState extends State<CheckPasswordWidget>
    with SingleTickerProviderStateMixin {
  CheckPasswordController controller = Get.find<CheckPasswordController>();

  late AnimationController animationCon;
  late CurvedAnimation scaleAnimation;

  @override
  void initState() {
    super.initState();

    animationCon = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    scaleAnimation = CurvedAnimation(
      parent: animationCon..forward(),
      curve: Curves.easeIn,
      reverseCurve: Curves.elasticOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // controller.errorPassword.value = null;
    // controller.passwordController.text = "";

    log('________ build __ CheckPasswordWidget');
    return Center(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            // color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsets.all(10),
                  child: Text("Please enter your password".tr),
                ),
                const SizedBox(height: 5),

                // old password
                Form(
                  key: controller.formKey,
                  child: Obx(
                    () => TextFormField(
                      onSaved: (val) {
                        // controller.mypassword = val!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'You must enter your password';
                        }
                        return null;
                      },
                      obscureText: controller.securePassword.value,
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        errorText: controller.errorPassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.securePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => controller.changPasswordVisible(),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: const Icon(Icons.password_rounded),
                        hintText: 'Password'.tr,
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                // forget password
                // Container(
                //   height: 35,
                //   margin: const EdgeInsets.only(bottom: 10),
                //   alignment: AlignmentDirectional.centerEnd,
                //   child: TextButton(
                //     onPressed: () => Get.toNamed(AppRoutes.forgetPassword),
                //     child: Text(
                //       AppLocalization.forgetPassword,
                //       style: Get.textTheme.labelSmall,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          await animationCon.reverse();
                          Navigator.of(context).pop(false);
                        },
                        child: Text("Cancel".tr),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => TextButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            if (await controller.checkPassword()) {
                              await animationCon.reverse();
                              widget.onCorrectCheck(
                                  controller.passwordController.text.trim());
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: controller.isWaiting.value
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(),
                                )
                              : Text("Check".tr),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckPasswordController extends GetxController {
  late GlobalKey<FormState> formKey;
  RxBool securePassword = true.obs;
  late TextEditingController passwordController;
  Rx<String?> errorPassword = Rx(null);
  RxBool isWaiting = false.obs;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    // passwordController.dispose();
    super.onClose();
    // Get.delete<CheckPasswordController>();
    // formKey.currentState?.deactivate();
  }

  void changPasswordVisible() {
    securePassword.value = !securePassword.value;
  }

  Future<bool> checkPassword() async {
    try {
      if (!(formKey.currentState?.validate() ?? false)) return false;

      isWaiting.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        log("::::::::::::User password: ${passwordController.text}");

        // Create a credential with the provided password
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: passwordController.text.trim());

        log("::::::::::::After credential: ${user.uid}");

        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // Password is correct
        isWaiting.value = false;
        return true;
      } else {
        log('::::::::: User is not signed in.');
        isWaiting.value = false;
        return false;
      }
    } catch (e) {
      log('Failed to check password: $e');
      errorPassword.value = "Failed to check password".tr;
      isWaiting.value = false;
      return false;
    }
  }
}
