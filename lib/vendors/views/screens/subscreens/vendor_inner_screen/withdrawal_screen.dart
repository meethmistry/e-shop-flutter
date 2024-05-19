// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends StatefulWidget {
  WithdrawalScreen({super.key});
  

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String amount;

  late String name;

  late String mobile;

  late String bankName;

  late String bankACName;

  late String bankACNumber;

  showSnack(String msg, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: bgColor,
        content: Text(
          msg,
          style: TextStyle(fontSize: 15),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        title: const Text(
          "Withdraw",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 3,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Amount Can't Be Empty!";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name Can't Be Empty!";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mo. Number Can't Be Empty!";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Bank Name Can't Be Empty!";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Bank Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Bank A/C Name Can't Be Empty!";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankACName = value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Bank A/C Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Bank A/C Number Can't Be Empty!";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankACNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bank A/c Number',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      EasyLoading.show(status: "Sending Request....");

                      await _firestore
                          .collection('withdrawal')
                          .doc(const Uuid().v4())
                          .set({
                        'amount': amount,
                        'name': name,
                        'mobile': mobile,
                        'bankName': bankName,
                        'bankAcName': bankACName,
                        'bankAcNumber': bankACNumber,
                        'vendorId': FirebaseAuth.instance.currentUser!.uid,
                      }).whenComplete(() {
                        EasyLoading.dismiss();
                        showSnack("Withdrawal Request is sent.",
                            Colors.green.shade900);
                        _formkey.currentState!.reset();
                      });
                    } else {
                      showSnack("Withdrawal Request is not sent.",
                          Colors.red.shade900);
                    }
                  },
                  child: Text(
                    "Get Cash",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.blue.shade900),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
