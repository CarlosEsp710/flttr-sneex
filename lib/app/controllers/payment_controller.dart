import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:flutter_sneex/app/constants/app_constants.dart';
import 'package:flutter_sneex/app/constants/controllers.dart';
import 'package:flutter_sneex/app/constants/firebase.dart';
import 'package:flutter_sneex/app/models/payment.dart';
import 'package:flutter_sneex/app/screens/payments/payments_screen.dart';
import 'package:flutter_sneex/app/utils/helpers/show_loading.dart';
import 'package:flutter_sneex/app/widgets/custom_text.dart';

class PaymentController extends GetxController {
  static PaymentController instance = Get.find();

  String collection = "payments";

  List<PaymentModel> payments = [];

  @override
  void onReady() async {
    super.onReady();
    Stripe.publishableKey =
        "pk_test_51JlhaxAsKbSxdpgFEZgwpMthWfw1pTGb1s2rxPvsT24Gl69aTp07FxPX4E6fMdSrsUwJIYtJ5uK3gkSLzGsnMM8r00wBZkpTgp";
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
  }

  Future<void> createPaymentMethod() async {
    try {
      int amount = (double.parse(
                  cartController.totalCartPrice.value.toStringAsFixed(2)) *
              100)
          .toInt();

      final response = await http.post(
        Uri.parse(
            'https://us-central1-flutterfire-codelab-test.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {
          'name': authController.userModel.value.name,
          'email': authController.userModel.value.email,
          'amount': amount.toString(),
        },
      );

      final jsonResponse = await jsonDecode(response.body);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['clientSecret'],
          merchantDisplayName: 'Flutter Sneex',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          style: ThemeMode.light,
          testEnv: true,
          merchantCountryCode: 'MX',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      authController.updateUserData({"cart": []});
      _addToCollection(
        paymentStatus: 'SUCCESS',
        paymentId: const Uuid().v1(),
      );
      Get.snackbar("Success", "Payment succeeded");
    } catch (e) {
      if (e is StripeException) {
        _addToCollection(
          paymentStatus: 'FAILED',
          paymentId: const Uuid().v1(),
        );
        _showPaymentFailedAlert('Error from Stripe: $e');
        logger.e(e.toString());
      } else {
        _addToCollection(
          paymentStatus: 'FAILED',
          paymentId: const Uuid().v1(),
        );
        _showPaymentFailedAlert('Unknown error: $e');
        logger.e(e.toString());
      }
    }
  }

  void _showPaymentFailedAlert(String e) {
    Get.defaultDialog(
      content: CustomText(
        text: e,
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomText(
              text: "Okay",
            ),
          ),
        ),
      ],
    );
  }

  _addToCollection({
    required String paymentStatus,
    required String paymentId,
  }) {
    String id = const Uuid().v1();
    firebaseFirestore.collection(collection).doc(id).set({
      "id": id,
      "clientId": authController.userModel.value.id,
      "status": paymentStatus,
      "paymentId": paymentId,
      "cart": authController.userModel.value.cartItemsToJson(),
      "amount": cartController.totalCartPrice.value.toStringAsFixed(2),
      "createdAt": DateTime.now().microsecondsSinceEpoch,
    });
  }

  getPaymentHistory() {
    showLoading();
    payments.clear();
    firebaseFirestore
        .collection(collection)
        .where(
          "clientId",
          isEqualTo: authController.userModel.value.id,
        )
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        PaymentModel payment = PaymentModel.fromMap(doc.data());
        payments.add(payment);
      });

      logger.i("length ${payments.length}");
      dismissLoadingWidget();
      Get.to(() => const PaymentsScreen());
    });
  }
}
