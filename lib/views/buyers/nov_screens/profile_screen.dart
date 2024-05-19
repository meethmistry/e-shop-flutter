import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/views/buyers/auth/login_screen.dart';
import 'package:e_shop/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:e_shop/views/buyers/inner_screens/order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('buyers');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Profile",
                style: TextStyle(letterSpacing: 3),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade900,
              actions: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.star),
                )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.blue.shade500,
                  backgroundImage: NetworkImage(data['profileImage']),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  data['fullName'],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  data['email'],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return EditProfileScreen(
                          userData: data,
                        );
                      },
                    ));
                  },
                  leading: Icon(Icons.edit),
                  title: Text("Edit profile"),
                ),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),
                const ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone"),
                ),
                const ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Cart"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CustomerOrderScreen();
                      },
                    ));
                  },
                  leading: Icon(Icons.shopping_bag),
                  title: Text("Orders"),
                ),
                ListTile(
                  onTap: () async {
                    await _auth.signOut().whenComplete(() {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ));
                    });
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                ),
              ],
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
