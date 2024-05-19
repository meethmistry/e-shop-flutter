import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartAttr with ChangeNotifier {
  final String productName;
  final String productId;
  final List imageUrl;
  int quantity;
  int productQuantity;
  final double price;
  final String vendorId;
  final String productSize;
  Timestamp schedualDate;

  CartAttr({
    required this.productName,
    required this.productId,
    required this.imageUrl,
    required this.quantity,
    required this.productQuantity,
    required this.price,
    required this.vendorId,
    required this.productSize,
    required this.schedualDate,
  });

  void increse() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
