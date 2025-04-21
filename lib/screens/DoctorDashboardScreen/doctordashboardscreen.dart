
import 'package:flutter/material.dart';
// ignore: unused_import
import 'components/doctordashboardscreen_body.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DoctorDashboardScreen'),
      ),
      body: DoctorDashboardScreen(),
    );
  }
}
    