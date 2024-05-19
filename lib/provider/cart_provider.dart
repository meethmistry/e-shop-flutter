import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/models/cart_attributes.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};
  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(
      String productName,
      String productId,
      List imageUrl,
      int quantity,
      int productQuantity,
      double price,
      String vendorId,
      String productSize,
      Timestamp schedualDate) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCart) => CartAttr(
              productName: existingCart.productName,
              productId: existingCart.productId,
              imageUrl: existingCart.imageUrl,
              quantity: existingCart.quantity + 1,
              productQuantity: existingCart.productQuantity,
              price: existingCart.price,
              vendorId: existingCart.vendorId,
              productSize: existingCart.productSize,
              schedualDate: existingCart.schedualDate));
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              productName: productName,
              productId: productId,
              imageUrl: imageUrl,
              quantity: quantity,
              productQuantity: productQuantity,
              price: price,
              vendorId: vendorId,
              productSize: productSize,
              schedualDate: schedualDate));
      notifyListeners();
    }
  }

  void increment(CartAttr cartAttr) {
    cartAttr.increse();
    notifyListeners();
  }

  void decrement(CartAttr cartAttr) {
    cartAttr.decrease();
    notifyListeners();
  }

  removeItem(productID) {
    _cartItems.remove(productID);
    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();
    notifyListeners();
  }
}
