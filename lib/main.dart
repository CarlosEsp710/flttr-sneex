import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_sneex/app/controllers/app_controller.dart';
import 'package:flutter_sneex/app/controllers/auth_controller.dart';
import 'package:flutter_sneex/app/controllers/cart_controller.dart';
import 'package:flutter_sneex/app/controllers/payment_controller.dart';
import 'package:flutter_sneex/app/controllers/product_controller.dart';
import 'package:flutter_sneex/app/constants/firebase.dart';
import 'package:flutter_sneex/app/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialization.then((value) {
    Get.put(AppController());
    Get.put(AuthController());
    Get.put(CartController());
    Get.put(PaymentController());
    Get.put(ProductController());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sneex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
