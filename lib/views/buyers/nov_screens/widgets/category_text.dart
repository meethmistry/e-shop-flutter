import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/views/buyers/nov_screens/category_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/widgets/home_products.dart';
import 'package:flutter/material.dart';

class CategorysListText extends StatefulWidget {
  const CategorysListText({super.key});

  @override
  State<CategorysListText> createState() => _CategorysListTextState();
}

class _CategorysListTextState extends State<CategorysListText> {
  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 8, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(
              fontSize: 19,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _categoryStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading Categories");
                }

                return Container(
                  padding: const EdgeInsets.only(left: 7),
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final categoryData = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ActionChip(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory =
                                            categoryData['categoryName'];
                                      });
                                    },
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(20),
                                            right: Radius.circular(20))),
                                    backgroundColor: Colors.blue[300],
                                    label: Text(
                                      categoryData['categoryName'],
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    )),
                              );
                            }),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CategoryPage();
                              },
                            ));
                          },
                          icon: const Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                );
              }),
          if (selectedCategory != null)
            HomeProductsWidget(categoryName: selectedCategory)
        ],
      ),
    );
  }
}
