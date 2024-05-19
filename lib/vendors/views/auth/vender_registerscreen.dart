import 'dart:typed_data';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_shop/vendors/controllers/vender_register_controller.dart';
import 'package:e_shop/vendors/views/auth/vendor_login_screen.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() => _VendorRegistrationScreen();
}

class _VendorRegistrationScreen extends State<VendorRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VenderController _venderController = VenderController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  Uint8List? _image;
  late String email;
  late String bName;
  late String phoneNumber;
  late String country;
  late String state;
  late String city;
  String taxStatus = "";
  late String taxNumber;

  bool _validateEmail(String email) {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.com");
    return emailValidatorRegExp.hasMatch(email);
  }

  bool _validateName(String bName) {
    final RegExp nameValidatorRegExp = RegExp('[a-zA-Z]');
    return nameValidatorRegExp.hasMatch(bName);
  }

  bool _validatePhoneNumber(String phoneNumber) {
    final RegExp phoneNumberValidatorRegExp = RegExp(r"(0/91)?[7-9][0-9]{9}");
    return phoneNumberValidatorRegExp.hasMatch(phoneNumber);
  }

  selectGalleryImage() async {
    Uint8List? im = await _venderController.pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List? im = await _venderController.pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  final List<String> _taxOptions = ['Yes', 'No'];
  _saveVenderDetails() async {
    try {
      if (taxStatus == "No") {
        taxNumber = "null";
      }
      if (_formKey.currentState!.validate()) {
        EasyLoading.show(status: 'Please Wait...');
        country = countryController.text;
        state = stateController.text;
        city = cityController.text;
        await _venderController
            .registerVendor(_image, bName, email, phoneNumber, country, state,
                city, taxStatus, taxNumber)
            .whenComplete(
          () {
            setState(
              () {
                _image = null;
                EasyLoading.dismiss();
                countryController.clear();
                stateController.clear();
                cityController.clear();
                taxNumberController.clear();
                _formKey.currentState!.reset();

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const VendorLoginScreen();
                }));
              },
            );
          },
        );
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e.toString() + "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 170,
            flexibleSpace: LayoutBuilder(
              // ignore: non_constant_identifier_names
              builder: (context, Constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.blue],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: _image != null
                            ? Image.memory(_image!)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 45,
                                    width: 90,
                                    child: IconButton(
                                      onPressed: () {
                                        selectGalleryImage();
                                      },
                                      icon: const Icon(CupertinoIcons.photo),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45,
                                    width: 90,
                                    child: IconButton(
                                      onPressed: () {
                                        selectCameraImage();
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.camera_fill),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Bussiness Name',
                      ),
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
                        bName = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 65,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tex Registered",
                            style: TextStyle(
                                color: Color.fromARGB(255, 112, 111, 111),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            height: 65,
                            width: 90,
                            child: DropdownButtonFormField(
                              hint: const Text("Select"),
                              borderRadius: BorderRadius.circular(10),
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.blue,
                                size: 28,
                              ),
                              items: _taxOptions.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  taxStatus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (taxStatus == "Yes")
                      TextFormField(
                        controller: taxNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Tax number',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Number can't be blank";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          taxNumber = value;
                        },
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: CountryStateCityPicker(
                        country: countryController,
                        state: stateController,
                        city: cityController,
                        dialogColor: Colors.white,
                        textFieldDecoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _saveVenderDetails();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        height: 55,
                        width: MediaQuery.of(context).size.width - 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
