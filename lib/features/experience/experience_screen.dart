import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/core/widgets/app_primary_button.dart';
import 'package:flutter_333/features/controllers/booking_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../booking/ticket_booking_screen.dart';

class ExperienceScreen extends StatefulWidget {
  final ExperienceModel experience;

  const ExperienceScreen({super.key, required this.experience});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final bookingController = Get.put(BookingController());
  final pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bookingController.getExperienceBooking(widget.experience.docId);
    });
  }

  @override
  void dispose() {
    Get.delete<BookingController>();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return RefreshIndicator(
      onRefresh: () async {
        await bookingController.getExperienceBooking(widget.experience.docId);
      },
      child: Scaffold(
        backgroundColor: Color(0XFFEEEEEE),
        body: ListView(
          children: [
            SizedBox(
              height: 250, // يمكنك تعديل الارتفاع حسب الحاجة
              child: Stack(
                children: [
                  
                  PageView.builder(
                    itemCount: widget.experience.photos.length,
                    scrollDirection: Axis.horizontal, // التمرير أفقي
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.experience.photos[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        progressIndicatorBuilder: (context, child, loadingProgress) {
                          // if (loadingProgress.progress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorWidget: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.broken_image, size: 50, color: Colors.red));
                        },
                      );
                    },
                  ),
      
                  Positioned(
                    top: 0,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CircleAvatar(
                        backgroundColor: Color(0XFFf0ecdc),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      icon: CircleAvatar(
                        // backgroundColor: Color(0XFFf0ecdc),
                        backgroundColor: Colors.grey[500],
                        radius: 15,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,// Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      icon: CircleAvatar(
                        // backgroundColor: Color(0XFFf0ecdc),
                        backgroundColor: Colors.grey[500],
                        radius: 15,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,// Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.experience.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: const Color(0XFF4d2f14),
                    ),
                  ),
                  const SizedBox(height: 5),
      
                  Text(
                    widget.experience.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0XFF4d2f14),
                    ),
                  ),
                  const SizedBox(height: 25),
      
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(widget.experience.date, style: const TextStyle(color: Color(0XFF4d2f14))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(widget.experience.time, style: const TextStyle(color: Color(0XFF4d2f14))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(Icons.price_change, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text("${widget.experience.price} SAR", style: const TextStyle(color: Color(0XFF4d2f14))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    // alignment: WrapAlignment.end,
                    children: [
                      Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(widget.experience.address, style: const TextStyle(color: Color(0XFF4d2f14))),
      
                      // Spacer(),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${widget.experience.location.latitude},${widget.experience.location.longitude}";
                          Uri uri = Uri.parse(googleMapsUrl);
                          
                          try {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } catch (e) {
                            log(' :::::::: Could not launch $googleMapsUrl');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ), child: Text('Go to the map'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
      
                  Obx(
                    () {
                      if (bookingController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (bookingController.experienceBooking.value != null) {
                        return Column(
                          children: [
                            // const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.people, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 8),
                                Text("${bookingController.experienceBooking.value?.ticketsNumber} PERSON (Ticket)", style: const TextStyle(color: Color(0XFF4d2f14))),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Icon(Icons.payment_rounded, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 8),
                                Text(bookingController.experienceBooking.value?.paymentMethod == 'Pay'? 'Google Pay' : 'Cash on Delivery', style: const TextStyle(color: Color(0XFF4d2f14))),
                              ],
                            ),
                          ],
                        );
                      }
      
                      return Container(
                        height: 75,
                        alignment: Alignment.center,
                        child: AppPrimaryButton(
                          text: 'Book Now',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TicketBookingScreen(experience: widget.experience)),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
