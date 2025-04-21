
import 'package:flutter/material.dart';
import 'components/dsignu_screen_body.dart';

class Dsignupscreen extends StatelessWidget {
  const Dsignupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dsignupscreen'),
      ),
      body: DsignupscreenBody(),
    );
  }
}
    