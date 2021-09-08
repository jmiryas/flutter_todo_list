import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red.shade300, primarySwatch: Colors.teal),
      title: 'Todo List',
      home: HomeScreen(),
    );
  }
}
