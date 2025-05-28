import 'package:flutter/material.dart';
import 'components/client_forgot_password_screen_body.dart';

class Clientforgotpasswordscreen extends StatelessWidget {
  const Clientforgotpasswordscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientforgotpasswordscreen'),
      ),
      body: ClientForgotPasswordScreen(),
    );
  }
}
    