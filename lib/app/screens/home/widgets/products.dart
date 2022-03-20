import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter_sneex/app/constants/controllers.dart';
import 'package:flutter_sneex/app/models/product.dart';
import 'package:flutter_sneex/app/screens/home/widgets/single_product.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .63,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 10,
        children: productController.products.map((ProductModel product) {
          return SingleProductWidget(
            product: product,
          );
        }).toList(),
      ),
    );
  }
}
