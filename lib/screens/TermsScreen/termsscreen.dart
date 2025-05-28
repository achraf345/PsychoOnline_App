
import 'package:flutter/material.dart';
import 'components/termsscreen_body.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TermsScreen'),
      ),
      body: TermsScreenBody(),
    );
  }
}
    