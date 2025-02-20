// import 'package:flutter/material.dart';
// import 'package:flutter_333/features/experience/widgets/app_header.dart';
// import 'package:flutter_stepindicator/flutter_stepindicator.dart';

// class TicketBookingScreen extends StatelessWidget {
//   const TicketBookingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ticket Booking'),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: CircleAvatar(
//             backgroundColor: Color(0XFFf0ecdc),
//             child: Icon(
//               Icons.arrow_back_ios_new,
//               color: Theme.of(context).primaryColor,
//               size: 22,
//             ),
//           ),
//         ),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
//             child: FlutterStepIndicator(
//               height: 20,
//               // disableAutoScroll: false,
//               list: ["0", "1", "2"],
//               onChange: (i){},
//               page: 1,
//               progressColor: Colors.grey,
//               division: 1,
//               negativeColor: Colors.grey,
//               positiveColor: Theme.of(context).primaryColor,
//               // positiveColor: Colors.black,
//               // positiveCheck: CircleAvatar(backgroundColor: Colors.red,),
//             ),
//           ),
            
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_333/core/models/experience_model.dart';
import 'package:flutter_333/features/booking/success_booking_screen.dart';
import 'package:flutter_333/features/home/widgets/home_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';

import '../../core/services/google_pay_service.dart';
import '../../core/widgets/app_primary_button.dart';
import '../controllers/booking_controller.dart';

class TicketBookingScreen extends StatefulWidget {
  const TicketBookingScreen({super.key, required this.experience});

  final ExperienceModel experience;

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}


final stepperController = ScrollController();

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  int _currentStep = 1; // الخطوة النشطة

  @override
  void dispose() {
    Get.delete<BookingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text("Ticket booking")),
      backgroundColor: Color(0XFFEEEEEE),
      body: SizedBox(
        // height: 200,
        child: Stepper(
          controller: stepperController,
          currentStep: _currentStep,
          type: StepperType.horizontal, // جعل الخطوات أفقية
          controlsBuilder: (context, details) => const SizedBox.shrink(),
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },

          steps: [
            Step(
              title: const Text(""),
              content: const SizedBox.shrink(), // لا نحتاج إلى محتوى هنا
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text(""),
              content: PageOne(experience: widget.experience, onBookNowTapped: () {
                setState(() {
                  _currentStep = 2;
                });
              }),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text(""),
              content: PageTwo(experience: widget.experience),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key, required this.experience, this.onBookNowTapped});

  final ExperienceModel experience;
  final void Function()? onBookNowTapped;

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.put(BookingController());
    return Column(
      children: [
        // const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            experience.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0XFF4d2f14),),
          ),
        ),
        const SizedBox(height: 20),

        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xffe0d3c4)
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Select number \nof tickets",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  // fontWeight: FontWeight.bold,
                  color: Color(0XFFab875f),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (bookingController.ticketNumber.value > 1) {
                        bookingController.ticketNumber.value--;
                      }
                    },
                    padding: EdgeInsets.zero,
                    icon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0XFFab875f), width: 2),
                        shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 8),
                      child: Text('-', style: TextStyle(fontSize: 35, color: Color(0XFFab875f))),
                    ),
                  ),

                  const SizedBox(width: 4),
                  Obx(
                    () => Text(
                      bookingController.ticketNumber.value.toString(),
                      style: TextStyle(
                        fontSize: 35,
                        color: Color(0XFFab875f),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  IconButton(
                    onPressed: () {
                      if (bookingController.checkAvailableSeats(experience)) {
                        if (bookingController.ticketNumber.value < 8) {
                          bookingController.ticketNumber.value++;
                        } else {
                          HomeHelper.showCustomSnackBar(context, "You can't book more than 8 tickets", isError: true);
                        }
                      } else {
                        HomeHelper.showCustomSnackBar(context, "Not enough seats", isError: true);
                      }
                    },
                    padding: EdgeInsets.zero,
                    icon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0XFFab875f), width: 2),
                        shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 8),
                      child: Text('+', style: TextStyle(fontSize: 35, color: Color(0XFFab875f))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(experience.price.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0XFFab875f)),),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // -- total
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 3),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Obx(
                () => Text(
                  '${experience.price * bookingController.ticketNumber.value} SAR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

         Container(
          height: 75,
          alignment: Alignment.center,
          child: AppPrimaryButton(
            text: 'Book Now',
            onPressed: onBookNowTapped,
          ),
        ),
      ],
    );
  }
}


class PageTwo extends StatelessWidget {
  const PageTwo({super.key, required this.experience});

  final ExperienceModel experience;

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();
    return Column(
      children: [
        _buildCustomContainer(
          context: context,
          title: "Checkout",
          children: [
            const SizedBox(height: 20),
            Text(
              experience.name,
              // "Join us for a traditional Al-Ardah performance",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFFab875f),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              // DateFormat("EEEE, d MMMM, h:mma").format(DateTime.now()),
              // experience.date + " " + experience.time,
              formatExperienceDate(experience.date, experience.time),
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                // fontWeight: FontWeight.bold,
                color: Color(0XFFab875f),
              ),
            ),

            const SizedBox(height: 30),
            Text.rich(
              style: TextStyle(
                fontSize: 22,
                color: Color(0XFFab875f),
                fontStyle: FontStyle.italic,
              ),
              TextSpan(
                children: [
                  TextSpan(text: "Quantity: ", style: TextStyle(fontWeight: FontWeight.w900)),
                  TextSpan(text: "${bookingController.ticketNumber.value} Ticket(s)", style: TextStyle())
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 20),

        // -- total
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 3),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              Obx(
                () => Text(
                  '${experience.price * bookingController.ticketNumber.value} SAR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Obx(() => _buildCustomContainer(
          context: context,
          title: " Choose your payment method:",
          height: 220,
          children: [
            RadioListTile(
              value: "Pay",
              groupValue: bookingController.paymentMethod.value,
              onChanged: (value) {
                bookingController.paymentMethod.value = value.toString();
              },
              title: Row(
                children: [
                  Image.asset("assets/icons/googlePay.png"),
                ],
              ),
            ),
            RadioListTile(
              value: "Cash",
              groupValue: bookingController.paymentMethod.value,
              onChanged: (value) {
                bookingController.paymentMethod.value = value.toString();
              },
              title: const Text("Cash on Delivery"),
            ),
          ]
        )),
        const SizedBox(height: 20),

        Obx(
          () {
            if (bookingController.isLoading.value) {
              return const CircularProgressIndicator();
            }

            if (bookingController.paymentMethod.value == "Pay") {
              return GooglePayButton(
                width: 300,
                paymentConfiguration: GooglePayService.defaultGooglePayConfig,
                type: GooglePayButtonType.book,
                paymentItems: [
                  PaymentItem(amount: '${bookingController.ticketNumber.value * experience.price}', label: 'label 1', status: PaymentItemStatus.final_price),
                  // PaymentItem(amount: '20.1', label: 'label 2'),
                ],
              );
            }
            return SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await bookingController.confirmBooking(
                    context,
                    experience: experience,
                    total: bookingController.ticketNumber.value * experience.price,
                  );
              
                  if (result) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessBookingScreen()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF4d2f14),
                  foregroundColor: Color(0xFFe0d3c4),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Confirm booking",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        ),
      ],
    );
  }

  String formatExperienceDate(String date, String time) {
    try {
      // دمج التاريخ والوقت في نص واحد
      String dateTimeString = "$date $time";

      // تحويل النص إلى كائن DateTime
      DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeString);

      // تنسيق التاريخ بالشكل المطلوب
      return DateFormat("EEEE, d MMMM, h:mma").format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid Date";
    }
  }

  Widget _buildCustomContainer({required BuildContext context, double height = 280, required String title, required List<Widget> children}) {
    return Container(
      width: 300,
      height: height,
      padding: EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, color: Colors.black)),
          const SizedBox(height: 2),

          Expanded(
            child: Container(
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}