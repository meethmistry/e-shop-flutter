import 'package:e_shop/views/buyers/nov_screens/widgets/banner_widget.dart';
import 'package:e_shop/views/buyers/nov_screens/widgets/category_text.dart';
import 'package:e_shop/views/buyers/nov_screens/widgets/search_input_screen.dart';
import 'package:e_shop/views/buyers/nov_screens/widgets/welcome_screen_text.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          WelcomeText(),
          SearchInputScreen(),
          BannerWidget(),
          CategorysListText(),
        ],
      ),
    );
  }
}


