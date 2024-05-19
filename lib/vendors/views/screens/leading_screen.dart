import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/vendors/models/vendor_user_model.dart';
import 'package:e_shop/vendors/views/auth/vendor_login_screen.dart';
import 'package:e_shop/vendors/views/auth/vendor_registr_screen.dart';
import 'package:e_shop/vendors/views/screens/main_vendors_screen.dart';

class LeadingScreen extends StatelessWidget {
  LeadingScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _vendorsStream =
      FirebaseFirestore.instance.collection('vendors');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _vendorsStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          if (!snapshot.data!.exists) {
            return const RegistrationScreen();
          }

          final data = snapshot.data!.data();
          VendorUserModel vendorUserModel =
              VendorUserModel.fromJson(data as Map<String, dynamic>);

          if (vendorUserModel.approved == true) {
            return const MainVendorsScreen();
          }

          return Center(
              child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  height: 180,
                  width: 180,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image.network(
                    vendorUserModel.storageImage.toString(),
                    fit: BoxFit.cover,
                  )),
              Text(
                vendorUserModel.bName.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Text(
                "Your Application has been sent  to admin.\nAdmin will get back to you soon",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const VendorLoginScreen(),
                    ));
                  },
                  child: const Text(
                    "Singout",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w800),
                  ))
            ],
          ));
        },
      ),
    );
  }
}
