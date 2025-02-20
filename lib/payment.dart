import 'package:flutter/material.dart';
import 'package:flutter_333/core/services/google_pay_service.dart';
import 'package:pay/pay.dart';

class PAymentScreen extends StatelessWidget {
  PAymentScreen({super.key});

  var googlePayButton = GooglePayButton(
    paymentConfiguration: GooglePayService.defaultGooglePayConfig,
    type: GooglePayButtonType.book,
    paymentItems: [
      PaymentItem(amount: '10.5', label: 'label 1', status: PaymentItemStatus.final_price),
      // PaymentItem(amount: '20.1', label: 'label 2'),
    ],
  );
var _paymentItems = [
      PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
      )
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            googlePayButton,
            // GooglePayButton(
            //   paymentConfiguration: GooglePayService.defaultGooglePayConfig,
            //   paymentItems: _paymentItems,
            //   // : GooglePayButtonStyle.black,
            //   type: GooglePayButtonType.pay,
            //   onPaymentResult: onGooglePayResult,
            // ),
            // ElevatedButton(onPressed: (){

            // }, child: Text('Pay'))
          ],
        ),
      ),
    );
  }

  // In your Stateless Widget class or State
      void onGooglePayResult(paymentResult) {
      // Send the resulting Google Pay token to your server or PSP
      }
}