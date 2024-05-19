import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/views/buyers/product_details/product_detail_screen.dart';
import 'package:flutter/material.dart';

class AllProductScreen extends StatelessWidget {
  const AllProductScreen({super.key, this.categoryData});

  final dynamic categoryData;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('productCategory', isEqualTo: categoryData['categoryName'])
        .where('approved', isEqualTo: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryData['categoryName'],
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade900,
              ),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 200 / 300),
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              return Container(
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailScreen(
                          productData: productData,
                        );
                      },
                    ));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          height: 170,
                          width: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      productData['imageUrlList'][0]),
                                  fit: BoxFit.cover)),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                productData['productName'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '₹ ${productData['productPrice']}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
