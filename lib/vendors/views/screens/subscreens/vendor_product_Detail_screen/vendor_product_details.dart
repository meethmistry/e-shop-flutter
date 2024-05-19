import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VendorProductDetailsScreen extends StatefulWidget {
  const VendorProductDetailsScreen({super.key, this.productData});

  final dynamic productData;

  @override
  State<VendorProductDetailsScreen> createState() =>
      _VendorProductDetailsScreenState();
}

class _VendorProductDetailsScreenState
    extends State<VendorProductDetailsScreen> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _brandName = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productDiscription = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();
  double? productPrice;
  int? productQuantity;

  @override
  void initState() {
    setState(() {
      _productName.text = widget.productData['productName'];
      _brandName.text = widget.productData['brandName'];
      _quantity.text = widget.productData['productQuantity'].toString();

      productQuantity = int.parse(widget.productData['productQuantity'].toString());

      _productPrice.text = widget.productData['productPrice'].toString();

      productPrice = double.parse(widget.productData['productPrice'].toString());
      _productDiscription.text = widget.productData['productDescription'];
      _productCategory.text = widget.productData['productCategory'];
    });
    super.initState();
  }

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "All Fileds Must be Filled",
          style: TextStyle(fontSize: 15),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: Text(widget.productData['productName']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _productName,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _brandName,
                decoration: const InputDecoration(labelText: 'Brand Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                onChanged: (value) {
                  productQuantity = int.parse(value);
                },
                controller: _quantity,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                onChanged: (value) {
                  productPrice = double.parse(value);
                },
                controller: _productPrice,
                decoration: const InputDecoration(labelText: 'Product Price'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _productDiscription,
                decoration:
                    const InputDecoration(labelText: 'Product Discription'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _productCategory,
                decoration:
                    const InputDecoration(labelText: 'Product Category'),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () async {
          if (productPrice != null && productQuantity != null) {
            EasyLoading.show(status: "Product Updating...");

            await _fireStore
                .collection('products')
                .doc(widget.productData['productID'])
                .update({
              'productName': _productName.text,
              'brandName': _brandName.text,
              'productQuantity': productQuantity,
              'productPrice': productPrice,
              'productDescription': _productDiscription.text,
              'productCategory': _productCategory.text,
            }).whenComplete(
              () {
                EasyLoading.dismiss();
                Navigator.pop(context);
              },
            );
          } else {
            showSnack();
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Update Product",
            style:
                TextStyle(letterSpacing: 3, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
