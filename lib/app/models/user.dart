import 'package:flutter_sneex/app/constants/app_constants.dart';
import 'package:flutter_sneex/app/models/cart_item.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const CART = "cart";

  String? id;
  String? name;
  String? email;
  List<CartItemModel>? cart;

  UserModel({
    this.id,
    this.name,
    this.email,
  });

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    name = data[NAME];
    email = data[EMAIL];
    cart = _convertCartItems(data[CART]);
  }

  List<CartItemModel> _convertCartItems(List cartFromFirestore) {
    List<CartItemModel> _result = [];

    logger.i(cartFromFirestore.length);

    cartFromFirestore.forEach((element) {
      _result.add(CartItemModel.fromMap(element));
    });

    return _result;
  }

  List cartItemsToJson() => cart!.map((item) => item.toJson()).toList();
}
