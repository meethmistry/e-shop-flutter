import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchInputScreen extends StatelessWidget {
  const SearchInputScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        child: TextField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Search for products',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}