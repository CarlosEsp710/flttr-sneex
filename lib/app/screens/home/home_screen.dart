import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter_sneex/app/constants/controllers.dart';
import 'package:flutter_sneex/app/screens/home/widgets/products.dart';
import 'package:flutter_sneex/app/screens/home/widgets/shopping_cart.dart';
import 'package:flutter_sneex/app/widgets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const CustomText(
          text: "Sneex",
          size: 24,
          weight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showBarModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: Colors.white,
                  child: const ShoppingCartWidget(),
                ),
              );
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [
            Obx(
              () => UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.black),
                accountName: Text(authController.userModel.value.name ?? ""),
                accountEmail: Text(authController.userModel.value.email ?? ""),
              ),
            ),
            ListTile(
              onTap: () async => paymentController.getPaymentHistory(),
              leading: const Icon(Icons.book),
              title: const Text("Payments"),
            ),
            ListTile(
              onTap: () => authController.signOut(),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log out"),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white30,
        child: const ProductsWidget(),
      ),
    );
  }
}
