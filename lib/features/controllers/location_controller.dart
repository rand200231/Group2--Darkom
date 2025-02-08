import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;
  late GoogleMapController mapController;

  // default coordinate
  final LatLng initialPosition = const LatLng(24.7136, 46.6753); // الرياض

  Rx<LatLng?> selectedLocation = Rx(null);
  RxString address = ''.obs;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapTap(LatLng position,
      {void Function(LatLng selectedLatLng, String address)?
          onSelectLocation}) async {
    selectedLocation(position);

    // get the address from the selected coordinate
    address.value = '';
    await getAddressFromLatLng(position);

    // send the locations values to the received function
    if (address.value.isNotEmpty) {
      onSelectLocation?.call(position, address.value);

      log('---- Run onSelectLocation');
    }
  }

  Future<void> getCurrentLocation(BuildContext context,
      {void Function(LatLng selectedLatLng, String address)?
          onSelectLocation}) async {
    try {
      isLoading(true);

      // التحقق من الأذونات
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        isLoading(false);
        return;
      }

      if (!await checkLocationPermission()) {
        isLoading(false);
        return;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      selectedLocation.value = currentLatLng;

      // get the address from the selected coordinate
      address.value = '';
      await getAddressFromLatLng(currentLatLng);

      // send the locations values to the received function
      if (address.value.isNotEmpty) {
        onSelectLocation?.call(currentLatLng, address.value);

        log('---- Run onSelectLocation');
      }

      // تحريك الكاميرا إلى الموقع الحالي
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 14.0));
    } catch (e) {
      HomeHelper.showCustomSnackBar(
          context, 'Error while get your location. Try again.',
          isError: true);
      print('Error getting current location: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  /// function to convert the coordinate to address
  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      isLoading(true); // show loading indicator
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        address.value =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      log(' ----- Error getting address: $e');
    } finally {
      isLoading(false); // hide loading indicator
    }
  }
}
