import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 10, right: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "How are you? What are you\nlooking for 👀",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SvgPicture.asset(
              'assets/icons/cart.svg',
              width: 21,
            ),
          ],
        ),
      ),
    );
  }
}