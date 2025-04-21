import 'package:flutter/material.dart';
import 'components/paymentsuccessscreen_body.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: const PaymentSuccessScreenBody(),
    );
  }
}
