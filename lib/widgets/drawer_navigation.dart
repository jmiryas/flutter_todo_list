import 'package:flutter/material.dart';

import '../screens/categories_screen.dart';
import '../screens/home_screen.dart';

class DrawerNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                accountName: Text(
                  "J. M. Iryas",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text("jmiryas@gmail.com")),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("Categories"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CategoriesScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
