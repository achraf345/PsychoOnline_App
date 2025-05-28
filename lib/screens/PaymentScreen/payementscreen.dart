import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> demandData;

  const PaymentScreen({super.key, required this.demandData, required paymentType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: PaymentScreen(demandData: demandData, paymentType: null,),
    );
  }
}
