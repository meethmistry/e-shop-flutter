// ignore_for_file: prefer_final_fields, unused_field

import 'package:e_shop/vendors/views/screens/subscreens/earning_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/edit_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/logout_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/vendor_orders_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/upload_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainVendorsScreen extends StatefulWidget {
  const MainVendorsScreen({super.key});

  @override
  State<MainVendorsScreen> createState() => _MainVendorsScreenState();
}

class _MainVendorsScreenState extends State<MainVendorsScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    EarningScreen(),
    UploadScreen(),
    EditScreen(),
    VendorOrderScreen(),
    LogoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (value) => {
                setState(() {
                  _pageIndex = value;
                }),
              },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.money_dollar,
                  color: _pageIndex == 0 ? Colors.blue : Colors.black,
                ),
                label: 'Earning'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.upload,
                  color: _pageIndex == 1 ? Colors.blue : Colors.black,
                ),
                label: 'Upload'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.edit,
                  color: _pageIndex == 2 ? Colors.blue : Colors.black,
                ),
                label: 'Edit'),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.shopping_cart,
                  color: _pageIndex == 3 ? Colors.blue : Colors.black,
                ),
                label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout_outlined,
                  color: _pageIndex == 4 ? Colors.blue : Colors.black,
                ),
                label: 'Logout'),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
