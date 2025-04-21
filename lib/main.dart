// ignore: unused_import
import 'package:awa/screens/AcceptClientScreen/acceptclientscreen.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:awa/screens/HomeScreen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Homescreen(), 
    );
  }
}
