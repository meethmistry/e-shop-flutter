import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, this.userData});

  final dynamic userData;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  String? address;

  @override
  void initState() {
    super.initState();
    setState(() {
      _fullName.text = widget.userData['fullName'];
      _email.text = widget.userData['email'];
      _phoneNumber.text = widget.userData['phoneNumber'];
      _address.text = widget.userData['address'];
      widget.userData['address'] != null
          ? _address.text = widget.userData['address']
          : _address.text = "";
      address = widget.userData['address'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          "Edit Profile",
          style: TextStyle(letterSpacing: 3, fontSize: 20, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade900,
                ),
                Positioned(
                  right: 38,
                  top: 30,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.photo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextFormField(
                controller: _fullName,
                decoration: InputDecoration(labelText: 'Enter Full Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Enter Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(labelText: 'Enter Phone Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextFormField(
                controller: _address,
                onChanged: (value) {
                  address = value;
                },
                decoration: InputDecoration(labelText: 'Enter Address'),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: "Updating");
            await _firebaseFirestore
                .collection('buyers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'fullName': _fullName.text,
              'email': _email.text,
              'phoneNumber': _phoneNumber.text,
              'address': address,
            });
            EasyLoading.dismiss();
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.sizeOf(context).width - 10,
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade900,
            ),
            child: Text(
              "Update Profile",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
