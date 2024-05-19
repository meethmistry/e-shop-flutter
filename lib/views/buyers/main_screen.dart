// import 'package:flutter/cupertino.dart';
// ignore_for_file: deprecated_member_use

import 'package:e_shop/views/buyers/nov_screens/cart_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/category_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/home_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/profile_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/search_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  List<Widget> _pages = [
    HomePage(),
    CategoryPage(),
    StorePage(),
    CartPage(),
    SearchPage(),
    ProfilePage(),
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
                icon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  width: 27,
                  color: _pageIndex == 0 ? Colors.blue : Colors.black,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/explore.svg',
                  width: 23,
                  color: _pageIndex == 1 ? Colors.blue : Colors.black,
                ),
                label: 'Category'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/shop.svg',
                  width: 23,
                  color: _pageIndex == 2 ? Colors.blue : Colors.black,
                ),
                label: 'Shop'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/cart.svg',
                  width: 23,
                  color: _pageIndex == 3 ? Colors.blue : Colors.black,
                ),
                label: 'Cart'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/search.svg',
                  width: 20,
                  color: _pageIndex == 4 ? Colors.blue : Colors.black,
                ),
                label: 'Search'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/account.svg',
                  width: 20,
                  color: _pageIndex == 5 ? Colors.blue : Colors.black,
                ),
                label: 'Account '),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
