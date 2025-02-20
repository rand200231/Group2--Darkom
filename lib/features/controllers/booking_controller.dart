import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/booking_model.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  final isLoading = false.obs;
  RxInt ticketNumber = 1.obs;
  RxString paymentMethod = "Cash".obs;

  Rx<BookingModel?> experienceBooking = Rx(null);

  bool checkAvailableSeats(ExperienceModel experience) {
    if (ticketNumber.value + 1 > (experience.availableSeats - experience.bookingSeats)) {
      return false;
    }
    return true;
  }

  Future<bool> confirmBooking(BuildContext context, {required ExperienceModel experience, required double total}) async {
    isLoading.value = true;
    try{
      if (ticketNumber.value > (experience.availableSeats - experience.bookingSeats)) {
        HomeHelper.showCustomSnackBar(context, 'Not enough seats', isError: true);
        return false;
      }
      final booking = BookingModel(
        experienceId: experience.docId,
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        ticketsNumber: ticketNumber.value,
        total: total,
        paymentMethod: paymentMethod.value,
        date: DateTime.now(),
      );
      log('::::::::::');

      await FirebaseFirestore.instance.collection('booking').add(booking.toMap());
      await updateBookingSeats(experience: experience);
      return true;
    } catch (e) {
      log('???????? Error in confirmBooking: $e');
      HomeHelper.showCustomSnackBar(context, 'Something error, Try again...');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> updateBookingSeats({required ExperienceModel experience}) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection('experiences')
        .doc(experience.docId)
        .update({'bookingSeats': experience.bookingSeats - ticketNumber.value});
    isLoading.value = false;
  }

  Future<void> getExperienceBooking(String experienceId) async {
    isLoading.value = true;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('booking')
        .where('experienceId', isEqualTo: experienceId)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      experienceBooking.value = BookingModel.fromMap(
        querySnapshot.docs.first.data(), querySnapshot.docs.first.id);

      log(':::::::::: Booking data: ${experienceBooking.value.toString()}');
    }
    isLoading.value = false;
  }
}