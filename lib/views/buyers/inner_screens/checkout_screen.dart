import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:e_shop/views/buyers/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');
    final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    return FutureBuilder<DocumentSnapshot>(
      future: buyers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue.shade900,
              title: Text(
                "Check Out",
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            body: SingleChildScrollView(
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
            ),
            bottomSheet: data['address'] == "" || data['address'] == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EditProfileScreen(
                              userData: data,
                            );
                          },
                        ));
                      },
                      child: Text("Enter Billing Address"),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        EasyLoading.show(status: 'Placing Order');
                        cartProvider.getCartItem.forEach((key, item) {
                          final orderId = Uuid().v4();
                          _fireStore.collection('orders').doc(orderId).set({
                            'orderId': orderId,
                            'vendor': item.vendorId,
                            'email': data['email'],
                            'phoneNumber': data['phoneNumber'],
                            'address': data['address'],
                            'buyerID': data['buyerID'],
                            'fullName': data['fullName'],
                            'profileImage': data['profileImage'],
                            'productName': item.productName,
                            'productPrice': item.price,
                            'productID': item.productId,
                            'imageUrl': item.imageUrl,
                            'productQuantity': item.quantity,
                            'productSize': item.productSize,
                            'schedualDate': item.schedualDate,
                            'orderDate': DateTime.now(),
                            'accepted': false,
                          }).whenComplete(() {
                            setState(() {
                              cartProvider.getCartItem.clear();
                            });
                            EasyLoading.dismiss();

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return MainScreen();
                              },
                            ));
                          });
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue.shade900,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "PLACE ORDER",
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

        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue.shade900,
          ),
        );
      },
    );
  }
}
