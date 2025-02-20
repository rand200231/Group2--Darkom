import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/widgets/app_header.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/location_controller.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen(
      {super.key, this.onSelectLocation, this.selectedLocation});

  final void Function(LatLng selectedLatLng, String address)? onSelectLocation;
  final LatLng? selectedLocation;

  // @override
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController(), permanent: false);
    log(' --- Selected Location : ${controller.selectedLocation.value}');
    log(' --- Selected Address : ${controller.address.value}');

    return Scaffold(
      appBar: const AppHeader(),
      body: Stack(
        children: [
          Obx(() => GoogleMap(
                onMapCreated: (mapController) {
                  controller.onMapCreated(mapController);

                  WidgetsBinding.instance.addPostFrameCallback((callback) {
                    if (selectedLocation != null) {
                      controller.selectedLocation.value = selectedLocation;
                      controller.mapController.animateCamera(
                          CameraUpdate.newLatLng(selectedLocation!));
                      controller.getAddressFromLatLng(selectedLocation!);
                    }
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition,
                  zoom: 15.0,
                ),
                onTap: (argument) => controller.onMapTap(argument,
                    onSelectLocation: onSelectLocation),
                minMaxZoomPreference: const MinMaxZoomPreference(0, 18),
                indoorViewEnabled: true,
                mapToolbarEnabled: true,
                // onCameraMove: ((position) => controller.selectedLocation.value = position),
                markers: controller.selectedLocation.value != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected-location'),
                          position: controller.selectedLocation.value!,
                        ),
                      }
                    : {},
              )),

          Obx(() {
            if (controller.isLoading.value) {
              return Positioned(
                bottom: 20,
                left: 20,
                right: 55,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          Obx(() {
            if (controller.selectedLocation.value != null) {
              return Positioned(
                bottom: 20,
                left: 20,
                right: 55,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          controller.address.isEmpty
                              ? 'Selected location: (${controller.selectedLocation.value!.latitude}, ${controller.selectedLocation.value!.longitude})'
                              : 'Selected location: (${controller.address.value})',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // my location button
          Positioned(
            top: 30,
            right: 20,
            child: InkWell(
              onTap: () => controller.getCurrentLocation(context,
                  onSelectLocation: onSelectLocation),
              child: const CircleAvatar(child: Icon(Icons.my_location)),
            ),
          ),
        ],
      ),
    );
  }
}
