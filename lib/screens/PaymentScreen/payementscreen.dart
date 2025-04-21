import 'package:awa/screens/PaymentScreen/components/payementscreen_body.dart';
import 'package:flutter/material.dart';

class PaymentLauncher extends StatelessWidget {
  const PaymentLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Launch Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(paymentType: 'Full Payment'), // ✅ Pass the type here
              ),
            );
          },
          child: Text('Proceed to Payment'),
        ),
      ),
    );
  }
}

// Your updated PaymentScreen is correct as is.
