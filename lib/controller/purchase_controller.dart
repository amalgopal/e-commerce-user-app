import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;
  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';
  late Razorpay _razorpay;

  @override
  void onInit() {
    orderCollection = firestore.collection('orders');
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void onClose() {
    _razorpay.clear(); // Clean up the instance when the controller is disposed
    super.onClose();
  }

  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    var options = {
      'key': 'rzp_test_bHdpqu07DltSYN',
      'amount': (price * 100).toInt(), // Ensure amount is in paisa and integer
      'name': item,
      'description': description,
      'prefill': {
        'contact': '', // Optionally, add prefill contact
        'email': '', // Optionally, add prefill email
      },
      'theme': {
        'color': '#F37254', // Optionally, customize the theme color
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar('Success', 'Payment is Successfully', colorText: Colors.green);
    // Do something when payment succeeds
    print('Payment Success: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Error', '${response.message}', colorText: Colors.red);
    // Do something when payment fails
    print('Payment Error: ${response.code} - ${response.message}');
  }
}
