import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_333/core/widgets/app_primary_button.dart';
import 'package:flutter_333/core/widgets/custom_labeled_textfield.dart';
import 'package:flutter_333/features/controllers/create_experience_controller.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:flutter_333/features/location_screen_local/location_screen_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'app_header.dart';

class CreateExperienceScreen extends StatefulWidget {
  const CreateExperienceScreen({super.key});

  @override
  State<CreateExperienceScreen> createState() => _CreateExperienceScreenState();
}

class _CreateExperienceScreenState extends State<CreateExperienceScreen> {

  final CreateExperienceController controller =
      Get.put(CreateExperienceController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchCategories(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppHeader(),
      body: Container(
        clipBehavior: Clip.hardEdge,
        width: ScreenUtil().screenWidth - 30.w,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius:
                BorderRadius.horizontal(right: Radius.circular(58.r))),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
          children: [
            Text("Create your new Experience",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                )),
            20.verticalSpace,
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  // - name
                  CustomLabeledTextField(
                    label: 'Name'.toUpperCase(),
                    hintText: 'Enter the name of the Experience',
                    fillColor: Colors.white.withOpacity(0.38),
                    labelColor: Colors.white,
                    inputTextColor: Colors.white,
                    controller: controller.nameController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  15.verticalSpace,

                  // - description
                  CustomLabeledTextField(
                    label: 'Description'.toUpperCase(),
                    hintText: 'Describe the Experience',
                    maxLines: 3,
                    fillColor: Colors.white.withOpacity(0.38),
                    labelColor: Colors.white,
                    inputTextColor: Colors.white,
                    controller: controller.descriptionController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  15.verticalSpace,

                  // - photos
                  CustomLabeledTextField(
                    label: 'Photo/s'.toUpperCase(),
                    hintText: 'Upload your images here',
                    readOnly: true,
                    fillColor: Colors.white.withOpacity(0.38),
                    labelColor: Colors.white,
                    inputTextColor: Colors.white,
                    suffixIcon: const Icon(Icons.add_a_photo_outlined),
                    onTap: () {
                      // Open the gallery to select images
                      controller.pickImages(context); // فتح معرض الصور
                    },
                    validation: (value) {
                      if (controller.selectedImages.isEmpty) {
                        return "You must upload image/s";
                      }
                      return null;
                    },
                  ),
                  10.verticalSpace,

                  // عرض الصور المختارة في ListView أفقي
                  Obx(() {
                    if (controller.selectedImages.isEmpty) {
                      return const SizedBox(); // لا تعرض شيئًا إذا لم تكن هناك صور
                    }
                    return SizedBox(
                      height: 100, // ارتفاع ListView
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                // عرض الصورة
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    controller.selectedImages[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const SizedBox(),
                                  ),
                                ),

                                // زر حذف الصورة
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Colors.transparent.withOpacity(0.36),
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      style: IconButton.styleFrom(
                                          shadowColor: Colors.white,
                                          elevation: 5,
                                          padding: const EdgeInsets.all(0)),
                                      onPressed: () {
                                        controller
                                            .removeImage(index); // حذف الصورة
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  5.verticalSpace,

                  // - category
                  Obx(() => _buildDropdownWidget(
                    context,
                    label: 'Category'.toUpperCase(),
                    hintText: 'Select a category',
                    onChanged: (value) {
                      controller.categoryController.text = value ?? '';
                    },
                    items: controller.categories,
                    // items: [
                    //   'Adventure',
                    //   'Culture',
                    //   'Food',
                    // ],
                  )),

                  15.verticalSpace,
                  Obx(() => _buildDropdownWidget(
                    context,
                    label: 'City'.toUpperCase(),
                    hintText: 'Select a city',
                    onChanged: (value) {
                      controller.cityController.text = value ?? '';
                    },
                    items: controller.cities,
                    // items: saudiCities,
                  )),
                  15.verticalSpace,

                  // - price and available seats
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomLabeledTextField(
                          label: 'Price (per participant)'.toUpperCase(),
                          keyboardType: TextInputType.number,
                          fillColor: Colors.white.withOpacity(0.38),
                          labelColor: Colors.white,
                          inputTextColor: Colors.white,
                          controller: controller.priceController,
                          suffixIcon: Center(
                              child: Text('SR',
                                  style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                  ))),
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            if (!value.isNumericOnly) {
                              return "Must contain numbers only.";
                            }
                            return null;
                          },
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: CustomLabeledTextField(
                          label: 'Available seats'.toUpperCase(),
                          keyboardType: TextInputType.number,
                          fillColor: Colors.white.withOpacity(0.38),
                          labelColor: Colors.white,
                          inputTextColor: Colors.white,
                          controller: controller.availableSeatsController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            if (!value.isNumericOnly) {
                              return "Must contain numbers only.";
                            }
                            return null;
                          },
                          suffixIcon: const Icon(Icons.chair),
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,

                  // - date and time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Obx(() => CustomLabeledTextField(
                              label: 'Date'.toUpperCase(),
                              hintText: controller.selectedDate.value != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(controller.selectedDate.value!)
                                  : 'Select date',
                              hintColor: controller.selectedDate.value != null
                                  ? Colors.white
                                  : null,
                              readOnly: true,
                              onTap: () async {
                                log('--- selected date: ${controller.selectedDate.value}');
                                await HomeHelper.pickDateAndTime(
                                    context, controller.selectedDate);
                                log('--- selected date: ${controller.selectedDate.value}');
                              },
                              fillColor: Colors.white.withOpacity(0.38),
                              labelColor: Colors.white,
                              inputTextColor: Colors.white,
                              suffixIcon: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2.5.sp))),
                                child: Icon(Icons.arrow_drop_down_outlined,
                                    size: 30.sp),
                              ),
                              validation: (value) {
                                if (controller.selectedDate.value == null) {
                                  return "This field is required";
                                }
                                return null;
                              },
                            )),
                      ),
                      10.horizontalSpace,
                      Expanded(
                          child: Obx(
                        () => CustomLabeledTextField(
                          label: 'Time'.toUpperCase(),
                          hintText: controller.selectedTime.value != null
                              ? HomeHelper.formatTime(
                                  controller.selectedTime.value!)
                              : 'Select time',
                          hintColor: controller.selectedTime.value != null
                              ? Colors.white
                              : null,
                          readOnly: true,
                          onTap: () {
                            HomeHelper.pickTime(
                                context, controller.selectedTime);
                          },
                          fillColor: Colors.white.withOpacity(0.38),
                          labelColor: Colors.white,
                          inputTextColor: Colors.white,
                          suffixIcon: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.5.sp))),
                            child: Icon(Icons.arrow_drop_down_outlined,
                                size: 30.sp),
                          ),
                          validation: (value) {
                            if (controller.selectedTime.value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                      )),
                    ],
                  ),
                  15.verticalSpace,

                  // - location
                  Obx(() => CustomLabeledTextField(
                        label: 'Location'.toUpperCase(),
                        hintText: controller.selectedAddress.isNotEmpty
                            ? controller.selectedAddress.value
                            : 'Enter the address or locate it on the map',
                        hintColor: controller.selectedAddress.isNotEmpty
                            ? Colors.white
                            : null,
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationScreen(
                                        selectedLocation:
                                            controller.selectedLatLng.value,
                                        onSelectLocation:
                                            (selectedLatLng, address) {
                                          controller.selectedLatLng.value =
                                              selectedLatLng;
                                          controller.selectedAddress.value =
                                              address;

                                          log('-------- inside onSelectLocation: address: ${controller.selectedAddress.value}');
                                        },
                                      )));
                        },
                        fillColor: Colors.white.withOpacity(0.38),
                        labelColor: Colors.white,
                        inputTextColor: Colors.white,
                        suffixIcon: const Icon(Icons.location_on_outlined),
                        validation: (value) {
                          if (controller.selectedLatLng.value == null ||
                              controller.selectedAddress.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      )),
                  15.verticalSpace,

                  Obx(() => AppPrimaryButton(
                        text: 'Submit Your Experience',
                        isLoading: controller.isLoading.value,
                        onPressed: () => controller.uploadExperience(context),
                      )),
                  15.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<String> saudiCities = [
  //   "Riyadh", "Jeddah", "Qassim", "Al Ula", "Asir",
  // ];

  Widget _buildDropdownWidget(
    BuildContext context, {
      required String label,
      required String? hintText,
      required List<String> items,
      required Function(String? value) onChanged,
    }
  ) {
    final controller = Get.find<CreateExperienceController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            // fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 3.h),
        DropdownButtonFormField(
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          //  const [
          //   DropdownMenuItem(value: 'Adventure', child: Text('Adventure')),
          //   DropdownMenuItem(value: 'Culture', child: Text('Culture')),
          //   DropdownMenuItem(value: 'Food', child: Text('Food')),
          // ],
          alignment: Alignment.center,
          dropdownColor: Theme.of(context).primaryColor,
          isDense: true,
          // isExpanded: true,

          iconSize: 0,
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
          // controller: controller.,
          // validator: validation,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
          // onTap: onTap,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
            // isCollapsed: true,
            hintText: hintText ?? label,
            hintStyle: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 13.sp),
            // prefixIcon: prefixIcon,
            suffixIcon: Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.5.sp))),
              child: Icon(Icons.arrow_drop_down_outlined, size: 30.sp),
            ),
            suffixIconConstraints:
                const BoxConstraints(maxWidth: 50, minWidth: 40),

            filled: true,
            isDense: true,
            fillColor: Colors.white.withOpacity(0.38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
