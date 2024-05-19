import 'package:e_shop/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargeShipping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider provider = Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            "Charge Shipping",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 4),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value!;
              provider.getFormData(chargeShhipping: _chargeShipping);
            });
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty && _chargeShipping == true) {
                  return 'Enter Shipping Charge.';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                provider.getFormData(shippingCharge: double.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Shipping Charge',
              ),
            ),
          ),
      ],
    );
  }
}
