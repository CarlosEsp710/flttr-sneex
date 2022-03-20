import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_sneex/app/constants/app_constants.dart';
import 'package:flutter_sneex/app/constants/controllers.dart';
import 'package:flutter_sneex/app/models/cart_item.dart';
import 'package:flutter_sneex/app/models/user.dart';
import 'package:flutter_sneex/app/models/product.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  RxDouble totalCartPrice = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    ever(authController.userModel, changeCartTotalPrice);
  }

  void addProductToCart(ProductModel product) {
    try {
      if (_isItemAlreadyInCart(product)) {
        Get.snackbar(
            'Check your cart', '${product.name} is already in your cart');
      } else {
        String itemId = const Uuid().v1().toString();
        authController.updateUserData({
          "cart": FieldValue.arrayUnion([
            {
              "id": itemId,
              "productId": product.id,
              "name": product.name,
              "cost": product.price,
              "image": product.image,
              "quantity": 1,
              "price": product.price,
            }
          ])
        });

        Get.snackbar('Item added', '${product.name} was added to your cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Cannot add item to cart');
      debugPrint(e.toString());
    }
  }

  void removeCartItem(CartItemModel item, {bool showAlert = true}) {
    try {
      authController.updateUserData({
        "cart": FieldValue.arrayRemove([item.toJson()])
      });
      if (showAlert) {
        Get.snackbar('Item removed', '${item.name} was removed from your cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Cannot remove item from cart');
      debugPrint(e.toString());
    }
  }

  changeCartTotalPrice(UserModel user) {
    totalCartPrice.value = 0.0;

    if (user.cart!.isNotEmpty) {
      for (var i = 0; i < user.cart!.length; i++) {
        totalCartPrice.value += user.cart![i].cost!;
      }
    }
  }

  bool _isItemAlreadyInCart(ProductModel product) =>
      authController.userModel.value.cart!
          .where((item) => item.productId == product.id)
          .isNotEmpty;

  void decreaseQuantity(CartItemModel item) {
    if (item.quantity == 1) {
      removeCartItem(item);
    } else {
      removeCartItem(item, showAlert: false);
      item.quantity = item.quantity! - 1;
      authController.updateUserData({
        "cart": FieldValue.arrayUnion([item.toJson()])
      });
    }
  }

  void increaseQuantity(CartItemModel item) {
    removeCartItem(item, showAlert: false);
    item.quantity = item.quantity! + 1;
    logger.i({"quantity": item.quantity});
    authController.updateUserData({
      "cart": FieldValue.arrayUnion([item.toJson()])
    });
  }
}
