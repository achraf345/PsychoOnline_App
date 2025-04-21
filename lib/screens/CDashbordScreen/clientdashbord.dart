
import 'package:flutter/material.dart';
import 'components/clientdashbord_body.dart';

class Cdashbordscreen extends StatelessWidget {
  const Cdashbordscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cdashbordscreen'),
      ),
      body: CdashbordscreenBody(),
    );
  }
}
    