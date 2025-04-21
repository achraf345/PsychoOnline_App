import 'package:flutter/material.dart';
import 'components/clogin_screen_body.dart';

class CLoginScreen extends StatelessWidget {
  const CLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CLoginScreenBody(),
      ),
    );
  }
}
