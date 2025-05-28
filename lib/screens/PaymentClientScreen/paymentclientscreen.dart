
import 'package:flutter/material.dart';
import 'components/paymentclientscreen_body.dart';

class PaymentClientScreen extends StatelessWidget {
  const PaymentClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaymentClientScreen'),
      ),
      body: PaymentClientScreenBody(),
    );
  }
}
    