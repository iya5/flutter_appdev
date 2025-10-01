import 'package:flutter/material.dart';
import 'package:flutter_appdev/homepage.dart';
import 'util/window_config.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowConfig.init(); 
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