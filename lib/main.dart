// ignore_for_file: unused_import

import 'package:e_shop/firebase_options.dart';
import 'package:e_shop/provider/cart_provider.dart';
import 'package:e_shop/provider/product_provider.dart';
import 'package:e_shop/vendors/views/auth/vendor_login_screen.dart';
import 'package:e_shop/vendors/views/screens/main_vendors_screen.dart';
import 'package:e_shop/views/buyers/auth/login_screen.dart';
import 'package:e_shop/views/buyers/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ProductProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return CartProvider();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue, fontFamily: 'Brand-Bold'),
        home: LoginScreen(),
        builder: EasyLoading.init(),
      ),
    ),
  );
}
