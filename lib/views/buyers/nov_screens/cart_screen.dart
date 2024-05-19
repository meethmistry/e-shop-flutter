import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/views/buyers/inner_screens/checkout_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart Screen",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 3),
        ),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
              onPressed: () {
                cartProvider.removeAllItem();
              },
              icon: Icon(
                CupertinoIcons.delete,
                color: Colors.white,
                size: 25,
              )),
        ],
      ),
      body: cartProvider.getCartItem.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 0,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: cartProvider.getCartItem.length,
                      itemBuilder: (context, index) {
                        final cartData =
                            cartProvider.getCartItem.values.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    height: 120,
                                    width: 160,
                                    child: Image.network(
                                      cartData.imageUrl[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10, top: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartData.productName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                      Text(
                                        "₹ ${cartData.price}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {},
                                        child: Text(cartData.productSize),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade900,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (cartData.quantity > 1) {
                                                  cartProvider
                                                      .decrement(cartData);
                                                }
                                              },
                                              icon: Icon(CupertinoIcons.minus),
                                              color: Colors.white,
                                            ),
                                            Text(
                                              cartData.quantity.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (cartData.productQuantity >
                                                    cartData.quantity) {
                                                  cartProvider
                                                      .increment(cartData);
                                                }
                                              },
                                              icon: Icon(CupertinoIcons.add),
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cartProvider
                                              .removeItem(cartData.productId);
                                        },
                                        icon: Icon(
                                            CupertinoIcons.cart_badge_minus),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.sizeOf(context).width - 10,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Cuntinue Shopping",
                  style: TextStyle(
                      letterSpacing: 3, color: Colors.white, fontSize: 22),
                ),
              ),
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: cartProvider.totalPrice == 0.00
              ? null
              : () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CheckOutScreen();
                    },
                  ));
                },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  cartProvider.totalPrice == 0.00 ? null : Colors.blue.shade900,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cartProvider.totalPrice > 0.0
                      ? "CHECK OUT \n₹${cartProvider.totalPrice}"
                      : "CHECK OUT",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Icon(
                  CupertinoIcons.arrow_right,
                  size: 25,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
