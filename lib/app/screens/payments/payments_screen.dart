import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_sneex/app/constants/controllers.dart';
import 'package:flutter_sneex/app/screens/payments/widgets/payment.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.grey.withOpacity(.1),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Payment History",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: paymentController.payments
                .map(
                  (payment) => PaymentWidget(
                    paymentsModel: payment,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
