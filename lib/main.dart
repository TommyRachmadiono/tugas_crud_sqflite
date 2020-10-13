import 'package:flutter/material.dart';
// import 'package:tugas_crud_sqflite/pages/login_page.dart';
import 'package:tugas_crud_sqflite/pages/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFLite',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}