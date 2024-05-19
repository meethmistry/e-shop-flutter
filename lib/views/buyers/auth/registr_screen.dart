import 'dart:typed_data';

import 'package:e_shop/controllers/auth_controllers.dart';
import 'package:e_shop/views/buyers/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class BuyersRegistrationScreen extends StatefulWidget {
  const BuyersRegistrationScreen({super.key});

  @override
  State<BuyersRegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<BuyersRegistrationScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String fullName;

  late String phoneNumber;

  late String password;

  Uint8List? _image;

  bool _validateEmail(String email) {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.com");
    return emailValidatorRegExp.hasMatch(email);
  }

  bool _validateName(String fullName) {
    final RegExp nameValidatorRegExp = RegExp('[a-zA-Z]');
    return nameValidatorRegExp.hasMatch(fullName);
  }

  bool _validatePhoneNumber(String phoneNumber) {
    final RegExp phoneNumberValidatorRegExp = RegExp(r"(0/91)?[7-9][0-9]{9}");
    return phoneNumberValidatorRegExp.hasMatch(phoneNumber);
  }

  bool _isLoading = false;

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "All fields must be required!",
          style: TextStyle(fontSize: 15),
        )));
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      await _authController
          .signUpUsers(email, fullName, phoneNumber, password, _image!)
          .whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _image = null;
          _isLoading = false;
        });
      });
    } else {
      _isLoading = false;
      showSnack();
    }
  }

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  cameraRogalleryImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.all(20),
          actions: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    selectGalleryImage();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tack image form gallery",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                        Icon(
                          Icons.image,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    selectCameraImage();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tack a new image",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                        Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create Customer's Account",
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blue,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                          ),
                    Positioned(
                        top: 70,
                        left: 45,
                        child: IconButton(
                          icon: Icon(
                                 _image == null
                              ?  CupertinoIcons.photo : null,
                                  color: Colors.blue,
                                  size: 22,
                                ),
                          onPressed: () {
                            cameraRogalleryImage();
                          },
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: "Enter Email"),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!_validateEmail(value)) {
                          return "Enter valid email";
                        }
                      } else {
                        return "Email can't be blank";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Enter Full Name"),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!_validateName(value)) {
                          return "Enter valid name";
                        }
                      } else {
                        return "Name can't be blank";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      fullName = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Enter Mobile Number"),
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!_validatePhoneNumber(value)) {
                          return "Enter valid number";
                        }
                      } else {
                        return "Number can't be blank";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Enter Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password can't be blank";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    signUpUser();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.blue.shade500),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
