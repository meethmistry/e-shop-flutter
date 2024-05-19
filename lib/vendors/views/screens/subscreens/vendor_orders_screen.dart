import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class VendorOrderScreen extends StatelessWidget {
  VendorOrderScreen({super.key});

  String formateData(date) {
    final outputDateFormat = DateFormat('dd/mm/yyyy');
    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
      .collection('orders')
      .where("vendor", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          "MY ORDERS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade900,
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await _fireStore
                            .collection('orders')
                            .doc(document['orderId'])
                            .update({
                              'accepted':false
                            });
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Reject',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await _fireStore
                            .collection('orders')
                            .doc(document['orderId'])
                            .update({
                              'accepted':true
                            });
                      },
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Accept',
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: document['accepted'] == true
                            ? const Icon(
                                Icons.delivery_dining,
                                color: Colors.blue,
                              )
                            : const Icon(Icons.access_time, color: Colors.blue),
                      ),
                      title: document['accepted'] == true
                          ? Text(
                              "Accepted",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                              ),
                            )
                          : Text(
                              "Not Accepted",
                              style: TextStyle(
                                color: Colors.red.shade900,
                              ),
                            ),
                      trailing: Text(
                        "Amount " + document['productPrice'].toStringAsFixed(2),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      subtitle: Text(
                        formateData(document['orderDate'].toDate()),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        "Order Details",
                        style: TextStyle(
                            color: Colors.blue.shade900, fontSize: 15),
                      ),
                      subtitle: const Text("View Order Details"),
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Image.network(document['imageUrl'][0]),
                          ),
                          title: Text(document['productName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "Quantity",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(document['productQuantity'].toString()),
                                ],
                              ),
                              document['accepted'] == true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Schedual Delivery Date",
                                        ),
                                        Text(
                                          formateData(document['schedualDate']
                                              .toDate()),
                                        ),
                                      ],
                                    )
                                  : Text(""),
                                   ListTile(
                                      title: const Text(
                                        "Buyer Details",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            document['fullName'],
                                          ),
                                          Text(
                                            document['email'],
                                          ),
                                          Text(
                                            document['address'],
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
