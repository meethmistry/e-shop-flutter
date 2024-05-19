// import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productData});

  final dynamic productData;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imgIndex = 0;
  String? selectedSize;
  String formateData(date) {
    final outputDateFormat = DateFormat('dd/mm/yyyy');
    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      selectedSize == null ? SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Size must be selected!",
          style: TextStyle(fontSize: 15),
        ),
      ) : SnackBar(
        backgroundColor: Colors.green.shade900,
        content: Text(
          "You added ${widget.productData['productName']} to your cart.",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productData['productName']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                      widget.productData['imageUrlList'][_imgIndex]),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: widget.productData['imageUrlList'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _imgIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                width: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue.shade500)),
                                child: Image.network(
                                    widget.productData['imageUrlList'][index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ))
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '₹ ${widget.productData['productPrice']}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                        letterSpacing: 2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productData['productName'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                ),
                ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Product Discription",
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      Text("View More",
                          style: TextStyle(color: Colors.blue.shade900)),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.productData['productDescription'],
                        style: TextStyle(
                            fontSize: 17, color: Colors.grey, letterSpacing: 1),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Product Shipping On",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                      ),
                      Text(
                        formateData(
                          widget.productData['schedualDate'].toDate(),
                        ),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text("Available Size",
                      style: TextStyle(color: Colors.blue.shade900)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['sizeList'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedSize ==
                                          widget.productData['sizeList'][index]
                                      ? Colors.blue.shade800
                                      : null,
                                  borderRadius: selectedSize ==
                                          widget.productData['sizeList'][index]
                                      ? BorderRadius.circular(20)
                                      : null,
                                ),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedSize =
                                          widget.productData['sizeList'][index];
                                    });
                                  },
                                  child: Text(
                                    widget.productData['sizeList'][index],
                                    style: TextStyle(
                                        color: selectedSize ==
                                                widget.productData['sizeList']
                                                    [index]
                                            ? Colors.white
                                            : Colors.blue.shade900),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: _cartProvider.getCartItem
                  .containsKey(widget.productData['productID'])
              ? null
              : () {
                  if (selectedSize != null) {
                    _cartProvider.addProductToCart(
                      widget.productData['productName'],
                      widget.productData['productID'],
                      widget.productData['imageUrlList'],
                      1,
                      widget.productData['productQuantity'],
                      widget.productData['productPrice'],
                      widget.productData['vendorId'],
                      selectedSize!,
                      widget.productData['schedualDate'],
                    );
                    showSnack();
                  } 
                },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _cartProvider.getCartItem
                      .containsKey(widget.productData['productID'])
                  ? Colors.grey
                  : Colors.blue.shade900,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.cart,
                  size: 25,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: _cartProvider.getCartItem
                          .containsKey(widget.productData['productID'])
                      ? Text(
                          "  IN Cart",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )
                      : Text(
                          "  Add To Cart",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
