import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  getFormData({
    String? productName,
    double? price,
    int? quantity,
    String? category,
    String? description,
    DateTime? schedualDate,
    List<String>? imageUrlList,
    bool? chargeShhipping,
    double? shippingCharge,
    String? brandName,
    List<String>? sizeList,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (price != null) {
      productData['productPrice'] = price;
    }
    if (quantity != null) {
      productData['productQuantity'] = quantity;
    }
    if (category != null) {
      productData['productCategory'] = category;
    }
    if (description != null) {
      productData['productDescription'] = description;
    }
    if (schedualDate != null) {
      productData['schedualDate'] = schedualDate;
    }
    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }
    if (chargeShhipping != null) {
      productData['chargeShhipping'] = chargeShhipping;
    }
    if (shippingCharge != null) {
      productData['shippingCharge'] = shippingCharge;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
