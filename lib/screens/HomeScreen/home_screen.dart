
import 'package:flutter/material.dart';
import 'components/home_screen_body.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homescreen'),
      ),
      body: HomescreenBody(),
    );
  }
}
    