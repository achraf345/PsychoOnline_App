
import 'package:flutter/material.dart';
import 'components/paiddemandscreen_body.dart';

class PaidDemandScreen extends StatelessWidget {
  const PaidDemandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaidDemandScreen'),
      ),
      body: PaidDemandScreenBody(doctorName: '',),
    );
  }
}
    