// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GeneralScreen extends StatefulWidget {
  GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _categoryList = [];

  _getCategories() async {
    return await _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      }
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  late String productName;

  bool _validateName(String productName) {
    final RegExp nameValidatorRegExp = RegExp('[a-zA-Z]');
    return nameValidatorRegExp.hasMatch(productName);
  }

  late String price;

  bool validatePrice(String price) {
    final RegExp priceValidatorRegExp = RegExp(r'^\d+(\.\d{1,2})?$');
    return priceValidatorRegExp.hasMatch(price);
  }

  late String quantity;

  bool validateQuantity(String quantity) {
    final RegExp quantityValidatorRegExp = RegExp(r'^[1-9]\d*$');
    return quantityValidatorRegExp.hasMatch(quantity);
  }

  late String selectedCategory;
  late String description;

  String date = "dd/mm/yyyy";
  String formateDate(date) {
    if (date != 'dd/mm/yyyy') {
      final outputDateFormate = DateFormat('dd/mm/yyyy');
      final outputDate = outputDateFormate.format(DateTime.parse(date));
      return outputDate;
    } else {
      return 'dd/mm/yyyy';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Enter Product Name"),
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
                  productName = value;
                  _productProvider.getFormData(productName: productName);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Enter Product Price"),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    if (!validatePrice(value)) {
                      return "Enter valid price";
                    }
                  } else {
                    return "Price can't be blank";
                  }
                  return null;
                },
                onChanged: (value) {
                  price = value;
                  _productProvider.getFormData(price: double.parse(price));
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Enter Product Quantity"),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    if (!validateQuantity(value)) {
                      return "Enter valid Quantity";
                    }
                  } else {
                    return "Quantity can't be blank";
                  }
                  return null;
                },
                onChanged: (value) {
                  quantity = value;
                  _productProvider.getFormData(quantity: int.parse(quantity));
                },
              ),
              const SizedBox(
                height: 15,
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
                      "Select Category",
                      style: TextStyle(
                          color: Color.fromARGB(255, 112, 111, 111),
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      height: 65,
                      width: 180,
                      child: DropdownButtonFormField(
                        hint: Container(
                            margin: const EdgeInsets.only(left: 80),
                            child: const Text(
                              "Select",
                            )),
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
                        items: _categoryList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;

                            _productProvider.getFormData(
                                category: selectedCategory);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLines: 8,
                maxLength: 800,
                decoration: const InputDecoration(
                    labelText: "Enter Product Descriptions",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onChanged: (value) {
                  description = value;

                  _productProvider.getFormData(description: description);
                },
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Set Schedule : ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(5000),
                          ).then((value) {
                            setState(() {
                              _productProvider.getFormData(schedualDate: value);
                              date = value.toString();
                            });
                          });
                        });
                      },
                      child: Text(formateDate(date)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
