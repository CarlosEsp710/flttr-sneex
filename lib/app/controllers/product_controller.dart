import 'dart:async';

import 'package:flutter_sneex/app/constants/firebase.dart';
import 'package:flutter_sneex/app/models/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  RxList<ProductModel> products = RxList<ProductModel>([]);
  String collection = 'products';

  @override
  void onReady() {
    super.onReady();
    products.bindStream(getAllProducts());
  }

  Stream<List<ProductModel>> getAllProducts() =>
      firebaseFirestore.collection(collection).snapshots().map((query) =>
          query.docs.map((item) => ProductModel.fromMap(item.data())).toList());
}
