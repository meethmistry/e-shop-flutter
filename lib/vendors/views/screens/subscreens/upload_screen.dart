// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/vendors/views/screens/main_vendors_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/upload_screens/attributes_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/upload_screens/general_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/upload_screens/images_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/upload_screens/shipping_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  UploadScreen({super.key});

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
        length: 4,
        child: Form(
          key: _formkey,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    child: Text("General"),
                  ),
                  Tab(
                    child: Text("Shipping"),
                  ),
                  Tab(
                    child: Text("Attributes"),
                  ),
                  Tab(
                    child: Text("Images"),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                GeneralScreen(),
                const ShoppingScreen(),
                const AttributeScreen(),
                const ImageScreen(),
              ],
            ),
            bottomSheet: GestureDetector(
              onTap: () async {
                EasyLoading.show(status: 'PleaseWait...');
                if (_formkey.currentState!.validate()) {
                  final productID = const Uuid().v4();
                  await _firestore.collection('products').doc(productID).set({
                    'productID': productID,
                    'productName': _productProvider.productData['productName'],
                    'productPrice':
                        _productProvider.productData['productPrice'],
                    'productQuantity':
                        _productProvider.productData['productQuantity'],
                    'productCategory':
                        _productProvider.productData['productCategory'],
                    'productDescription':
                        _productProvider.productData['productDescription'],
                    'schedualDate':
                        _productProvider.productData['schedualDate'],
                    'imageUrlList':
                        _productProvider.productData['imageUrlList'],
                    'chargeShhipping':
                        _productProvider.productData['chargeShhipping'],
                    'shippingCharge':
                        _productProvider.productData['shippingCharge'],
                    'brandName': _productProvider.productData['brandName'],
                    'sizeList': _productProvider.productData['sizeList'],
                    'vendorId': FirebaseAuth.instance.currentUser!.uid,
                    'approved':false,
                  }).whenComplete(() {
                    _productProvider.clearData();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        EasyLoading.dismiss();
                        return const MainVendorsScreen();
                      },
                    ));
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                      letterSpacing: 3, fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }
}
