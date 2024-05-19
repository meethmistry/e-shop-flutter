import 'package:e_shop/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AttributeScreen extends StatefulWidget {
  const AttributeScreen({super.key});

  @override
  State<AttributeScreen> createState() => _AttributeScreenState();
}

class _AttributeScreenState extends State<AttributeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController sizeController = TextEditingController();
  bool _isSizeEntered = false;
  bool _isSave = false;
  final List<String> sizeList = [];
  bool _validateName(String productName) {
    final RegExp nameValidatorRegExp = RegExp('[a-zA-Z]');
    return nameValidatorRegExp.hasMatch(productName);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider provider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
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
              provider.getFormData(brandName: value);
            },
            decoration: const InputDecoration(
              labelText: 'Brand',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, right: 10),
                width: 240,
                height: 60,
                child: TextFormField(
                  controller: sizeController,
                  onChanged: (value) {
                    setState(() {
                      _isSizeEntered = true;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Size',
                  ),
                ),
              ),
              _isSizeEntered == true
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          sizeList.add(sizeController.text);
                          sizeController.clear();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20, left: 10),
                        alignment: Alignment.center,
                        height: 60,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4),
                        ),
                      ),
                    )
                  : const Text(""),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: sizeList.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    sizeList[index] + "  ",
                    style: const TextStyle(
                        letterSpacing: 2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                );
              },
            ),
          ),
          if (sizeList.isNotEmpty)
            GestureDetector(
              onTap: () {
                provider.getFormData(sizeList: sizeList);
                setState(() {
                  _isSave = true;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 10),
                alignment: Alignment.center,
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _isSave == true ? "Saved" : "Save",
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
