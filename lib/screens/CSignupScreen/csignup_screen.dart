import 'package:awa/screens/CSignupScreen/components/csignup_screen_body.dart';
import 'package:flutter/material.dart';

class CSignupscreen extends StatelessWidget {
  const CSignupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: CSignupscreenBody(),
      ),
    );
  }
}
