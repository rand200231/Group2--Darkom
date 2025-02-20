import 'package:pay/pay.dart';


class GooglePayService {
  static const String googlePay = 'google_pay';


  static final defaultGooglePayConfig = PaymentConfiguration.fromJsonString(_sampleGooglePayConfig);
  // static final defaultApplePayConfig = PaymentConfiguration.fromJsonString(defaultApplePay);

  static final String _sampleGooglePayConfig = '''{
    "provider": "google_pay",
    "data": {
        "environment": "TEST",
        "apiVersion": 2,
        "apiVersionMinor": 0,
        "allowedPaymentMethods": [
            {
                "type": "CARD",
                "tokenizationSpecification": {
                    "type": "PAYMENT_GATEWAY",
                    "parameters": {
                        "gateway": "example",
                        "gatewayMerchantId": "gatewayMerchantId"
                    }
                },
                "parameters": {
                    "allowedCardNetworks": [
                        "VISA",
                        "MASTERCARD"
                    ],
                    "allowedAuthMethods": [
                        "PAN_ONLY",
                        "CRYPTOGRAM_3DS"
                    ],
                    "billingAddressRequired": true,
                    "billingAddressParameters": {
                        "format": "FULL",
                        "phoneNumberRequired": true
                    }
                }
            }
        ],
        "merchantInfo": {
            "merchantId": "BCR2DN4T77JMTQ3F",
            "merchantName": "Darkom App"
        },
        "transactionInfo": {
            "countryCode": "SA",
            "currencyCode": "SAR"
        }
    }
}''';
}