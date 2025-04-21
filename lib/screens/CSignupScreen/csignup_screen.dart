import 'package:flutter/material.dart';
import 'components/csignup_screen_body.dart';

class CSignupscreen extends StatelessWidget {
  const CSignupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CSignupscreenBody(),
      ),
    );
  }
}
