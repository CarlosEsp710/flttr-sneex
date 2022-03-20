import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_sneex/app/constants/controllers.dart';
import 'package:flutter_sneex/app/screens/home/widgets/cart_item.dart';
import 'package:flutter_sneex/app/widgets/custom_button.dart';
import 'package:flutter_sneex/app/widgets/custom_text.dart';

class ShoppingCartWidget extends StatelessWidget {
  const ShoppingCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: CustomText(
                text: "Shopping Cart",
                size: 24,
                weight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => Column(
                children: authController.userModel.value.cart!
                    .map(
                      (cartItem) => CartItemWidget(
                        cartItem: cartItem,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 30,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            child: Obx(
              () => CustomButton(
                text:
                    "Pay (\$${cartController.totalCartPrice.value.toStringAsFixed(2)})",
                onTap: () => paymentController.createPaymentMethod(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
