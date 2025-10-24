import 'package:flutter/material.dart';
import 'package:flutter_appdev/homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lab_home_c',
      home: Homepage(title: "Homepage"),
    );
  }
}