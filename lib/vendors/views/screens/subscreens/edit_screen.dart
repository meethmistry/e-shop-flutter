import 'package:e_shop/vendors/views/screens/subscreens/edit_tab_screens/published_screen.dart';
import 'package:e_shop/vendors/views/screens/subscreens/edit_tab_screens/unpublished_screen.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade900,
            title: Text(
              "Manage Products",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white),
            ),
            bottom: TabBar(tabs: [
              Tab(
                child: Text(
                  "Published",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white),
                ),
              ),
              Tab(
                child: Text("Unpublished",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white)),
              ),
            ]),
          ),
          body: TabBarView(children: [
            PublishedTab(),
            UnpublishedTab(),
          ],),
        ));
  }
}
